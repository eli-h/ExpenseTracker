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
        Expense(title: "Mario Party", amount: 90.0, date: Date(), category: "Electronics", notes: "fun game"),
        Expense(title: "Shell Gas", amount: 20.0, date: Date(), category: "Fuel", notes: "Half tank"),
        Expense(title: "Shish", amount: 12.0, date: Date(), category: "Food", notes: "Tasty"),
        Expense(title: "Rolex", amount: 9000.0, date: Date(), category: "Shopping", notes: "bougie"),
        Expense(title: "Netflix", amount: 10.0, date: Date(), category: "Subscriptions", notes: "friends and the office")
    ]
    
    let categories: [String] = ["Fuel", "Food", "Shopping", "Electronics", "Subscriptions"]
    
    func getExpensesTotal() -> String {
        var total = 0.0
        
        for expense in expenses {
            total += expense.amount
        }
        
        return String(format: "%.2f", total)
    }
    
    mutating func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
}
