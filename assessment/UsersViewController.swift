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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.reloadData()
       
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        APIManager.getUsers { (User, errort) in
            DispatchQueue.main.async {
            if errort == nil{
                self.users = User!
                
            }else{
                print("error")
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
        tableViewCell.genderOutlet.text = users?.data[indexPath.row].gender.rawValue
        tableViewCell.statusOutlet.text = users?.data[indexPath.row].status.rawValue
        db.insert(id: (users?.data[indexPath.row].name)!, name: users?.data[indexPath.row].name ?? "user",email:users?.data[indexPath.row].email ?? "email"
                  ,gender: users?.data[indexPath.row].gender.rawValue ?? "Male", status: users?.data[indexPath.row].status.rawValue ?? "Active")

        // missing
        // change the color of gender
        
            return tableViewCell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
