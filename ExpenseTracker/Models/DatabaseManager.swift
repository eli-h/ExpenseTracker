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
    
    let passcodeTable = Table("passcode")
    let passcode = Expression<String>("passcode")
    
    let expenseTable = Table("expenses")
    let title = Expression<String>("title")
    let amount = Expression<Double>("amount")
    let date = Expression<Double>("date")
    let category = Expression<String>("category")
    let notes = Expression<String>("notes")
    
    func initDatabase(path: String) {
        //connect to db
        let db = try! Connection("\(path)/db.sqlite3")
        
        //create passcode table if it doesnt exist
        try! db.run(passcodeTable.create(ifNotExists: true) { t in
            t.column(passcode)
        })
        
        //create expenses table if it doesnt exist
        try! db.run(expenseTable.create(ifNotExists: true) { t in
            t.column(title)
            t.column(amount)
            t.column(date)
            t.column(category)
            t.column(notes)
        })
    }
    
    func connectToDb(path: String) -> Connection {
        return try! Connection("\(path)/db.sqlite3")
    }
    
    func createPassword(path: String, newPasscode: String) {
        let db = try! Connection("\(path)/db.sqlite3")

        let insert = passcodeTable.insert(passcode <- newPasscode)
        try! db.run(insert)
        print("password successfully created")
    }
    
    func validateLogin(path: String, enteredPasscode: String) -> Bool {
        let db = try! Connection("\(path)/db.sqlite3")
        
        do {
            let dbPasscodes = try db.prepare(passcodeTable)
            for p in dbPasscodes {
                print("login valid")
                return p[passcode] == enteredPasscode
            }
        } catch {
            print(error)
        }
        print("login invalid")
        return false
    }
    
    func addExpenseToDb(path: String, expense: Expense) {
        let db = try! Connection("\(path)/db.sqlite3")

        let insert = expenseTable.insert(
            title <- expense.title,
            amount <- expense.amount,
            date <- expense.date,
            category <- expense.category,
            notes <- expense.notes
            )
        try! db.run(insert)
        print("expense successfully added to db")
    }
    
    func getExpensesFromDb(path: String) -> [Expense] {
        var expenses: [Expense] = []
        let db = try! Connection("\(path)/db.sqlite3")
        
        do {
            let dbExpenses = try db.prepare(expenseTable)
            
            for e in dbExpenses {
                let eTitle = e[title]
                let eAmount = e[amount]
                let eDate = e[date]
                let eCategory = e[category]
                let eNotes = e[notes]
                
                expenses.append(Expense(
                    title: eTitle,
                    amount: eAmount,
                    date: eDate,
                    category: eCategory,
                    notes: eNotes
                ))
            }
        } catch {
            print(error)
        }
        
        print("expenses updated from db")
        return expenses
    }
}

