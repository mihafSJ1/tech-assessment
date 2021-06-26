//
//  ViewController.swift
//  assessment
//
//  Created by Mihaf on 16/11/1442 AH.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: -  outlets
    @IBOutlet weak var sendButtonOutlet: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var connectButtonOutlet: UIButton!
    @IBOutlet weak var usersButtonOutlet: UIButton!
    
    //MARK: -  variables
    
    //MARK: -  life cycle functions 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK: -  helper functions

    @IBAction func sendMessage(_ sender: Any) {
    }
    @IBAction func connectSocket(_ sender: Any) {
    }

}

