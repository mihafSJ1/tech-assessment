
import Foundation
import SQLite3

class SQLHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "techn-assessment.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
     
            return db
        }
    }
    
    func createTable(){
           let createTableString = "CREATE TABLE IF NOT EXISTS users(Id INTEGER PRIMARY KEY,name TEXT,email TEXT, gender TEXT,status TEXT);"
           var createTableStatement: OpaquePointer? = nil
           if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
           {
               if sqlite3_step(createTableStatement) == SQLITE_DONE
               {
                   print("users table created.")
               
               } else {
              
               }
           } else {
              
           sqlite3_finalize(createTableStatement)
       }
    }
    
    func insert(name:String,email:String, gender:String,status:String){
        if read(){
         
        
        let insertStatementString = "INSERT INTO users (Id, name, email,gender,status) VALUES (NULL, ?, ?, ?,? );"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (gender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (status as NSString).utf8String, -1, nil)
         
         
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
             
            } else {
                print("Could not insert row.")
               
            }
        } else {
            print("INSERT statement could not be prepared.")
         
            
        }
        sqlite3_finalize(insertStatement)
        }
      
    }
 
    func read()->Bool {
           let queryStatementString = "SELECT * FROM users;"
           var queryStatement: OpaquePointer? = nil
       
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            return false
            // to check if the table is full or not
            // no need to insert the users every time while fetching them from thee API
       
           } else {
               print("SELECT statement could not be prepared")
            return true
           }
           sqlite3_finalize(queryStatement)
        
       
       }
    
 

    
}
