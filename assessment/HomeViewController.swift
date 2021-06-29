//
//  ViewController.swift
//  assessment
//
//  Created by Mihaf on 16/11/1442 AH.
//

import UIKit
import Starscream



class HomeViewController: UIViewController,WebSocketDelegate, UITextFieldDelegate {
  
    
  
  
    
   
    

    //MARK: -  outlets
    @IBOutlet weak var sendButtonOutlet: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var connectButtonOutlet: UIButton!
    @IBOutlet weak var connectTilte: UILabel!
    @IBOutlet weak var usersButtonOutlet: UIButton!
    
    //MARK: -  variables
    var isConnected = false // to check if the socket is connected or not
    
    var socket: WebSocket!
    
    // UI colors
    let lightBlue = UIColor(hexString: "#B3DACC")
    let lightGray =  UIColor(hexString: "#D6D6D6")
    
    //MARK: -  life cycle functions 

    override func viewDidLoad() {
        super.viewDidLoad()
        initiateSocket()
        message.delegate = self//  assign  textfield delegate
        disableButton(button: sendButtonOutlet)
        UI()


    }
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
              
           }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
        
    //MARK: -  text filed delegate methods

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isConnected {
            sendButtonOutlet.isEnabled = true
        
       }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isConnected {
            enableButton(button: sendButtonOutlet)

       }
         return true;

     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            message.resignFirstResponder()
            return true
        }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if message.text == ""{
//            sendButtonOutlet.isEnabled = false
            disableButton(button: sendButtonOutlet)
        }
         return true;
     }
    //MARK: -  webcokcet delegate method
    func didReceive(event: WebSocketEvent, client: WebSocket) {
         switch event {
         case .connected(let headers):
            isConnected = true
            connectTilte.text = "Connected to web socket"
            connectButtonOutlet.setTitle("Disconnect", for:.normal)
            if message.text != "" {
              enableButton(button: sendButtonOutlet)
         
            }
           
            print("websocket is connected: \(headers)")
         case .disconnected(let reason, let code):
             isConnected = false
             print("websocket is disconnected: \(reason) with code: \(code)")
             connectTilte.text = "websocket is disconnected"
             connectButtonOutlet.setTitle("Connect", for:.normal)
         case .text(let string):
             print("Received text: \(string)")
            //add alert
         case .binary(let data):
             print("Received data: \(data.count)")
         //add alert
         case .ping(_):
             break
         case .pong(_):
             break
         case .viabilityChanged(_):
             break
         case .reconnectSuggested(_):
             break
         case .cancelled:
             isConnected = false
         case .error(let error):
             isConnected = false
             alert(Message: "websocket encountered an error", title: "Alert")
         }
     }
 
    
   
    //MARK: -  helper functions
    
    func initiateSocket(){
        // to create the request to the socket
        let url = URL(string: "ws://echo.websocket.org")!
        let request = URLRequest(url: url)
        let websocket = WebSocket(request: request)
       
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    func UI(){
        usersButtonOutlet.layer.cornerRadius = 20
        connectButtonOutlet.layer.cornerRadius = 20
        message.layer.cornerRadius = 20
        sendButtonOutlet?.roundCorners([.topRight,.bottomRight], radius: 10)
        
    }
    func alert(Message:String,title:String){
        let alert = UIAlertController(title: title, message:Message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        clear(textFiled: message) // to clear
    }
    
    func clear(textFiled:UITextField){
        textFiled.text = ""// to clear text field
    }
    func enableButton(button:UIButton){
        button.isEnabled = true
        button.backgroundColor = lightBlue
    }
    func disableButton(button:UIButton){
        button.isEnabled = false
        button.backgroundColor = lightGray
    }
    
  
    
    //MARK: -  hide and show keyboard
    func subscribeToKeyboardNotifications() {

          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
      }

    func unsubscribeFromKeyboardNotifications() {

          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    
    @objc func keyboardWillShow(_ notification:Notification) {
       if (message.isEditing){
       
        if view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
          }
        }
      }

      @objc func keyboardWillHide(_ notification:Notification) {
            self.view.frame.origin.y = 0
      }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

          let userInfo = notification.userInfo
          let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
          return keyboardSize.cgRectValue.height
      }
    
     func prepareTextField(textField: UITextField, defaultText: String) {
            message.text = defaultText
          
            
    }
    
    
    //MARK: -  Action functions
    @IBAction func sendMessage(_ sender: Any) {
        if isConnected{
    
            if (message.text != "" ) {
                socket.write(string: message.text!)
                alert(Message: message.text! , title: "Message Recived!")
        }else{
                alert(Message: "Enter a message", title: "Alert")
        }
        }else{
                disableButton(button: sendButtonOutlet)
            

        }
    }
    @IBAction func connectSocket(_ sender: Any) {
        if !isConnected{
            socket.connect()
          
   
        }else{
            socket.disconnect()
            disableButton(button: sendButtonOutlet)
   
            
        }
        
    }

}

//MARK: -  extension
extension UIView {
   func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath

      self.layer.mask = mask
   }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

