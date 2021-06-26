
import Foundation
import SQLite3

class SQLHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "tech-assessment.sqlite"
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
    
    func createTable() {
           let createTableString = "CREATE TABLE IF NOT EXISTS users(Id INTEGER PRIMARY KEY,name TEXT,email TEXT, gender TEXT,status TEXT);"
           var createTableStatement: OpaquePointer? = nil
           if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
           {
               if sqlite3_step(createTableStatement) == SQLITE_DONE
               {
                   print("users table created.")
               } else {
                   print("users table could not be created.")
               }
           } else {
               print("CREATE TABLE statement could not be prepared.")
           }
           sqlite3_finalize(createTableStatement)
       }
    
    
    func insert(id:String, name:String,email:String, gender:String,status:String)
     {
      
        
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
 
//         let insertStatementString = "INSERT INTO users (id, name, gender, status) VALUES (?, ?, ?, ?);"
//         var insertStatement: OpaquePointer? = nil
//         if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(insertStatement, 1, Int32(id)!)
//            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 2, (gender as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 2, (status as NSString).utf8String, -1, nil)
//
//             if sqlite3_step(insertStatement) == SQLITE_DONE {
//                 print("Successfully inserted row.")
//             } else {
//                 print("Could not insert row.")
//             }
//         } else {
//             print("INSERT statement could not be prepared.")
//         }
//         sqlite3_finalize(insertStatement)
  
    
    
}
