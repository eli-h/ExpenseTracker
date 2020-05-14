//
//  ExpenseBrain.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import Foundation

struct ExpenseBrain {
    let categories: [String] = ["Fuel", "Food", "Shopping", "Electronics", "Subscriptions"]

    var allExpenses: [Expense] = [
        Expense(title: "Mario Party", amount: 90.0, date: Date().timeIntervalSince1970, category: "Electronics", notes: "fun game"),
        Expense(title: "Shell Gas", amount: 20.0, date: Date().timeIntervalSince1970, category: "Fuel", notes: "Half tank"),
        Expense(title: "Shish", amount: 12.0, date: Date().timeIntervalSince1970, category: "Food", notes: "Tasty"),
        Expense(title: "Rolex", amount: 9000.0, date: Date().timeIntervalSince1970, category: "Shopping", notes: "bougie"),
        Expense(title: "Netflix", amount: 10.0, date: Date().timeIntervalSince1970, category: "Subscriptions", notes: "friends and the office")
    ]
    
    var filteredExpenses: [Expense] = []
    var filters = Filters(fromDate: 0.0, toDate: Date().timeIntervalSince1970, categories: [])
    
    func getExpensesTotal() -> String {
        var total = 0.0
        
        for expense in filteredExpenses {
            total += expense.amount
        }
        
        return String(format: "%.2f", total)
    }
    
    private func filterByDate(fromDate: Double, toDate: Double, expenses: [Expense]) -> [Expense] {
        var results: [Expense] = []
        
        for expense in expenses {
            if expense.date >= fromDate && expense.date <= toDate {
                results.append(expense)
            }
        }
        
        return results
    }
    
    private func filterByCategories(categories: [String], expenses: [Expense]) -> [Expense] {
        var results: [Expense] = []
        
        if categories.count == 0 {
            return expenses
        }
        
        for expense in expenses {
            let expenseCategories = expense.category.components(separatedBy: ",")
            let intersection = Set(expenseCategories).intersection(Set(categories))
            if intersection.count > 0 {
                results.append(expense)
            }
        }
        
        return results
    }
    
    mutating func filterExpenses() {
        var results: [Expense] = allExpenses
        results = filterByDate(fromDate: filters.fromDate, toDate: filters.toDate, expenses: results)
        results = filterByCategories(categories: filters.categories, expenses: results)
        filteredExpenses = results
    }
    
    mutating func updateFilters(newFilters: Filters) {
        self.filters = newFilters
    }
    
    func formatDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyy"
        
        return dateFormatter.string(from: date)
    }
    
    mutating func updateAllExpensesFromDb() {
        let databaseManager = DatabaseManager()
        allExpenses = databaseManager.getExpensesFromDb(path: K.dbFilePath)
    }
}
