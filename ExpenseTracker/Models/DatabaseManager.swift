//
//  DatabaseManager.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    
    func initDatabase(path: String) {
        //connect to db
        let db = try! Connection("\(path)/db.sqlite3")
        
        //create passcode table if it doesnt exist
        let passcodeTable = Table("passcode")
        let passcode = Expression<String>("passcode")
        
        try! db.run(passcodeTable.create(ifNotExists: true) { t in
            t.column(passcode)
        })
        
        //create expenses table if it doesnt exist
//        let expenseTable = Table("expenses")
//        let title = Expression<String>("title")
//        let amount = Expression<Double>("amount")
//        let date = Expression<String>("date")
//        let category = Expression<String>("category")
//        let notes = Expression<String>("notes")
    }
    
    func connectToDb(path: String) -> Connection {
        return try! Connection("\(path)/db.sqlite3")
    }
    
    func createPassword(path: String, newPasscode: String) {
        let db = try! Connection("\(path)/db.sqlite3")
        
        let passcodeTable = Table("passcode")
        let passcode = Expression<String>("passcode")

        let insert = passcodeTable.insert(passcode <- newPasscode)
        try! db.run(insert)
    }
    
    func validateLogin(path: String, enteredPasscode: String) -> Bool {
        let db = try! Connection("\(path)/db.sqlite3")
        
        let passcodeTable = Table("passcode")
        let passcode = Expression<String>("passcode")
        
        do {
            let dbPasscodes = try db.prepare(passcodeTable)
            for p in dbPasscodes {
                return p[passcode] == enteredPasscode
            }
        } catch {
            print(error)
        }

        return false
    }
}

