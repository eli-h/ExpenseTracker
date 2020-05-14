//
//  ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController {
    
    var expenseBrain = ExpenseBrain()
    var total = 0.0
    
    @IBOutlet weak var expenseTableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTableView.dataSource = self
        expenseTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseBrain.updateExpensesFromDb()
        totalLabel.text = "Total: \(expenseBrain.getExpensesTotal())"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowExpenseViewController {
            let indexPath = expenseTableView.indexPathForSelectedRow
            destination.expense = expenseBrain.expenses[indexPath!.row]
        }
    }
}

extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseBrain.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = expenseBrain.expenses[indexPath.row].title
        cell.detailTextLabel?.text = String(expenseBrain.expenses[indexPath.row].amount)
        return cell
    }
}

extension ExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.showExpenseSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
