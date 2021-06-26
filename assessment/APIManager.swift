//
//  API.swift
//  assessment
//
//  Created by Mihaf on 16/11/1442 AH.
//

import Foundation


class APIManager {
    static func getUsers(_ completion: @escaping (_ users:User?, _ err: Error?)->Void) {
       
        let request = URLRequest(url: URL(string: "https://gorest.co.in/public-api/users")!)
       let session = URLSession.shared
       let task = session.dataTask(with: request) { data, response, error in
           if error != nil{
           print(error)
           completion(nil,error)
            
       return
           }
              
   guard let code = (response as? HTTPURLResponse)?.statusCode else{
                 let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                                      print(error)
   
                                      completion (nil,error)
                                      return
                      }
                
           print(String(data: data!, encoding: .utf8)!)
           if code  >= 200  && code < 300 {
        
               do {
                   
               let users = try JSONDecoder().decode(User.self , from: data!)
               completion(users,nil)
                print(users,"users")
           
           } catch {
                print(error.localizedDescription)
               completion(nil,error)
              }
           }else{
               print(error!)
         completion(nil,error!)
           }

   }//completion
       task.resume()
}
static func convert(_ url:String,completion: @escaping (_ data:Data?, _ err: Error?)->Void) {

    
    let request = URLRequest(url: URL(string:url)!)
       let session = URLSession.shared
       let task = session.dataTask(with: request) { data, response, error in
           if error != nil{
      
           print(error)
           completion(nil,error)
            
       return
           }
          completion(data,nil)
    
}
    task.resume()

}
}
