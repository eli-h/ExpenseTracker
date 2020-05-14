//
//  ExpenseTrackerTests.swift
//  ExpenseTrackerTests
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import XCTest
@testable import ExpenseTracker

class ExpenseTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var testExpenses: [Expense] = [
        Expense(title: "Mario Party", amount: 90.0, date: 1488914132.0, category: "Electronics", notes: "fun game"),
        Expense(title: "Shell Gas", amount: 20.0, date: 1520450132.0, category: "Fuel", notes: "Half tank"),
        Expense(title: "Shish", amount: 12.0, date: Date().timeIntervalSince1970, category: "Food", notes: "Tasty"),
        Expense(title: "Rolex", amount: 9000.0, date: Date().timeIntervalSince1970, category: "Shopping", notes: "bougie"),
        Expense(title: "Netflix", amount: 10.0, date: Date().timeIntervalSince1970, category: "Subscriptions", notes: "friends and the office")
    ]

    func testGetExpensesTotal() {
        var expenseBrain = ExpenseBrain()
        expenseBrain.filteredExpenses = testExpenses
        let total = expenseBrain.getExpensesTotal()
        XCTAssert(total == "9132.00", "Total was calulated improperly")
    }
    
    func testFilterExpenses() {
        var expenseBrain = ExpenseBrain()
        expenseBrain.allExpenses = testExpenses
        let filters = Filters(fromDate: 1488914131.0, toDate: 1520450133.0, categories: ["Electronics","Fuel"])
        expenseBrain.updateFilters(newFilters: filters)
        expenseBrain.filterExpenses()
        XCTAssert(expenseBrain.filteredExpenses.count == 2, "returned incorrect number of expenses")
    }
}
