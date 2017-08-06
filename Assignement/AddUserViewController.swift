//
//  AddUserViewController.swift
//  Assignement
//
//  Created by girish potnuru on 8/5/17.
//  Copyright © 2017 girish potnuru. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    var userDict: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        if(self.userDict != nil) {
            self.nameTextField.text = self.userDict?["name"] as? String
            self.descriptionTextField.text = self.userDict?["description"] as? String
            self.title = "Edit Task"
        }else {
            self.title = "Create Task"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        self.createUser()
    }
    func createUser() {
        
        let user = NSMutableDictionary()
        if(self.userDict != nil){
            
            user.setValue(self.nameTextField.text, forKey: "name")
            user.setValue(self.descriptionTextField.text, forKey: "description")
            user.setValue(Date().toString(dateFormat: "MM-dd-yyyy hh:mm") , forKey: "dateupdated")
            DatabaseManager.sharedInstance.update(tableName: "Tasks", ColumnsAndValues: user, id: userDict?["ID"] as! String)
        }
        else {
        
        let user = NSMutableDictionary()
        user.setValue(self.nameTextField.text, forKey: "name")
        user.setValue(self.descriptionTextField.text, forKey: "description")
        user.setValue(Date().toString(dateFormat: "MM-dd-yyyy hh:mm") , forKey: "datecreated")
        print("user is \(user)")
        DatabaseManager.sharedInstance.insert("Tasks", ColumnsAndValues: user)
        }
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
