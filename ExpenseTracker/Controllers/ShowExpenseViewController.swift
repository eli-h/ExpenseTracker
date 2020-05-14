//
//  ShowExpenseViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit

class ShowExpenseViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    var expense = Expense(title: "Default", amount: 0.0, date: Date().timeIntervalSince1970, category: "Electronics", notes: "This is the default expense")
    var expenseBrain = ExpenseBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        let formattedDate = expenseBrain.formatDate(date: expense.date)
        
        titleLabel.text = "Title: \(expense.title)"
        amountLabel.text = "Amount: \(expense.amount)"
        dateLabel.text = "Date: \(formattedDate)"
        categoryLabel.text = "Category: \(expense.category)"
        notesLabel.text = "Notes: \(expense.notes)"
    }
}
