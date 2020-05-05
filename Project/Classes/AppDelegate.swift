//
//  AppDelegate.swift
//  Project
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import SQLite3
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //To keep track of score for current game
    var mainScore: Int = 0
    
    // difficulty level: Easy = 0, Medium = 1 and Hard = 2
    var difficultyLevel: Int = 0 //default is easy
    
    //universal variable to control volume for app from 1-100
    var volumeLevel: Float = 60.0 //default is 60
    
    var databaseName : String? = "project.db"
    var databasePath : String?
    var player : [ScoreData] = []
    var playerName : PlayerData?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        return true
    }
    
    func readDataFromDatabase() {
        player.removeAll()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from scoreRecord"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let scoreId : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let score : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let cdate = sqlite3_column_text(queryStatement, 2)
                    let cimage = sqlite3_column_text(queryStatement, 3)
                    
                    let date = String(cString: cdate!)
                    let image = String(cString : cimage!)
                    
                    let data : ScoreData = ScoreData.init()
                    data.initWithData(theRow: scoreId, theScore: score, theDate: date, theImage:  image)
                    player.append(data)
                    
                    print("Query result")
                    print("\(scoreId) | \(score) | \(date) | \(image)")
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
    }
    // Implemeneted readNameFromDatabase by Ravneet Raina
    func readNameFromDatabase() {
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Name Query Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from player"
            print("\(queryStatementString)")
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    
                    let pName = String(cString : cname!)
                    
                    let data : PlayerData = PlayerData.init()
                    data.initWithData(theRow: id, theName:  pName)
                    playerName = data
                    print("Query result")
                    print("\(id) | \(playerName)")
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
    }
    
    func insertIntoDatabase(player : ScoreData) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString : String = "insert into scoreRecord values(NULL, ?, ?, ?)"
            if sqlite3_prepare(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                let score = Int(player.score!)
                let dateStr = player.date! as NSString
                let imageStr = player.image! as NSString
                
                sqlite3_bind_int(insertStatement, 1, Int32(score))
                sqlite3_bind_text(insertStatement, 2, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, imageStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowId)")
                }
                else{
                    print("Could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else{
                print("Insert statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    func getHighScore(){
        player.removeAll()
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from scoreRecord order by score desc LIMIT 1"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let scoreId : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let score : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let cdate = sqlite3_column_text(queryStatement, 2)
                    let cimage = sqlite3_column_text(queryStatement, 3)
                    
                    let date = String(cString: cdate!)
                    let image = String(cString : cimage!)
                    
                    let data : ScoreData = ScoreData.init()
                    data.initWithData(theRow: scoreId, theScore: score, theDate: date, theImage:  image)
                    player.append(data)
                    
                    print("Query result")
                    print("\(scoreId) | \(score) | \(date) | \(image)")
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
    }
    
    func checkAndCreateDatabase() {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

