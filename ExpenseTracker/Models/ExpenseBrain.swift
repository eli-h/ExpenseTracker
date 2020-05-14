//
//  ExpenseBrain.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import Foundation

struct ExpenseBrain {
    var expenses: [Expense] = [
        Expense(title: "Mario Party", amount: 90.0, date: Date().timeIntervalSince1970, category: "Electronics", notes: "fun game"),
        Expense(title: "Shell Gas", amount: 20.0, date: Date().timeIntervalSince1970, category: "Fuel", notes: "Half tank"),
        Expense(title: "Shish", amount: 12.0, date: Date().timeIntervalSince1970, category: "Food", notes: "Tasty"),
        Expense(title: "Rolex", amount: 9000.0, date: Date().timeIntervalSince1970, category: "Shopping", notes: "bougie"),
        Expense(title: "Netflix", amount: 10.0, date: Date().timeIntervalSince1970, category: "Subscriptions", notes: "friends and the office")
    ]
    
    let categories: [String] = ["Fuel", "Food", "Shopping", "Electronics", "Subscriptions"]
    
    func getExpensesTotal() -> String {
        var total = 0.0
        
        for expense in expenses {
            total += expense.amount
        }
        
        return String(format: "%.2f", total)
    }
    
    func formatDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyy"
        
        return dateFormatter.string(from: date)
    }
    
    mutating func updateExpensesFromDb() {
        let databaseManager = DatabaseManager()
        expenses = databaseManager.getExpensesFromDb(path: K.dbFilePath)
    }
}
