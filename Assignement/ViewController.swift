//
//  ViewController.swift
//  Assignement
//
//  Created by girish potnuru on 8/5/17.
//  Copyright © 2017 girish potnuru. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tasksTblview: UITableView!
    @IBOutlet weak var tasksHeaderLabel: UILabel!

    var allTasks = NSMutableArray()
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "List All Tasks"

       _ = DatabaseManager.sharedInstance.openDatabase()
        self.createTable()
        
        self.query()

    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    self.query()
    }
    
    
    
    //id, name, description, dateCreated, dateUpdated
    func createTable()  {
    _ = DatabaseManager.sharedInstance.createTable("Tasks", Fields: "ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,description TEXT,datecreated TEXT NOT NULL,dateupdated TEXT")
    }
    
    
    func query() {
        
     self.allTasks = DatabaseManager.sharedInstance.query(["ID","name","description","datecreated","dateupdated"], FROM: "Tasks", WHERE: "")
        print("dataResult \(self.allTasks)")
        
        if self.allTasks.count == 0 {
            self.tasksTblview.tableHeaderView = tasksHeaderLabel;
        }else {
            self.tasksTblview.tableHeaderView = nil;
        }
        self.tasksTblview.reloadData()
        
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  self.allTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let userDict = self.allTasks[indexPath.row] as? NSDictionary
        tblViewCell.textLabel?.text = userDict?["name"] as? String
        tblViewCell.detailTextLabel?.text = userDict?["description"] as? String
        return tblViewCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.deleteuser(indexPath: indexPath)
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let userDict = self.allTasks[indexPath.row] as? NSDictionary
            // share item at indexPath
            self.addOrUpdateUser(userDict: userDict)
        }
        
        share.backgroundColor = UIColor.blue
        
        return [delete, share]
    }

    func deleteuser(indexPath:IndexPath) {
        let userDict = self.allTasks[indexPath.row] as? NSDictionary
        print("\(userDict?["ID"] as! String)")
        DatabaseManager.sharedInstance.delete(tableName: "Tasks", id:userDict?["ID"] as! String)
        self.query()
    }
    
    
    @IBAction func createuser(_ sender: Any) {
        
        self.addOrUpdateUser(userDict: nil)
       
    }
    
    func addOrUpdateUser(userDict:NSDictionary?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "adduser") as! AddUserViewController
        if(userDict != nil){
            controller.userDict = userDict
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
   
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

