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
    
    var expense = Expense(title: "Default", amount: 0.0, date: Date(), category: "Electronics", notes: "This is the default expense")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Title: \(expense.title)"
        amountLabel.text = "Amount: \(expense.amount)"
        dateLabel.text = "Date: \(expense.date)"
        categoryLabel.text = "Category: \(expense.category)"
        notesLabel.text = "Notes: \(expense.notes)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
