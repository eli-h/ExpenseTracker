//
//  Constants.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//
import Foundation

struct K {
    static let goToExpenseSegue = "goToExpense"
    static let cellIdentifier = "ExpenseCell"
    static let showExpenseSegue = "ExpenseToShowExpense"
    static let dbFilePath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first!
}
