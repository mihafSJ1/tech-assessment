//
//  UsersViewController.swift
//  assessment
//
//  Created by Mihaf on 16/11/1442 AH.
//

import UIKit
import SQLite3
class UsersViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    // variables
    var users : User?
    var db:SQLHelper = SQLHelper()
    
    //MARK: -  life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.reloadData()
       
     
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        APIManager.getUsers { (User, error) in
            DispatchQueue.main.async {
            if error == nil{
                self.users = User!
                
            }else{
                
                print("error")
                self.alert(Message: "Error in loading data", title: "Alert")
                
            }
       
        }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          
        
        }
          
       
       }
    

    // MARK: - Table view deleagate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.data.count ?? 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let tableViewCell  = tableView.dequeueReusableCell(withIdentifier: "usercell")! as! UserCellTableViewCell
        tableViewCell.nameOutlet.text = users?.data[indexPath.row].name
        tableViewCell.emailOutlet.text = users?.data[indexPath.row].email
        
        if users?.data[indexPath.row].gender.rawValue == "Male"{
            tableViewCell.genderOutlet.textColor = .blue
        }else{
            tableViewCell.genderOutlet.textColor = .red
        }
        tableViewCell.genderOutlet.text = users?.data[indexPath.row].gender.rawValue
        tableViewCell.statusOutlet.text = users?.data[indexPath.row].status.rawValue
        db.insert(name: users?.data[indexPath.row].name ?? "user",email:users?.data[indexPath.row].email ?? "email"
                  ,gender: users?.data[indexPath.row].gender.rawValue ?? "Male", status: users?.data[indexPath.row].status.rawValue ?? "Active")


        
            return tableViewCell
    }
    // MARK: - Helper functions
    func alert(Message:String,title:String){
        let alert = UIAlertController(title: title, message:Message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
 
    }
}

