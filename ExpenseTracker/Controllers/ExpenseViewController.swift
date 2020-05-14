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
        updateExpenseTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateExpenseTable), name: NSNotification.Name(rawValue: K.updateExpenseTableNotification), object: nil)
    }
    
    @objc func updateExpenseTable() {
        expenseBrain.updateAllExpensesFromDb()
        expenseBrain.filterExpenses()
        totalLabel.text = "Total: \(expenseBrain.getExpensesTotal())"
        expenseTableView.reloadData()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.goToFiltersSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShowExpenseViewController {
            let indexPath = expenseTableView.indexPathForSelectedRow
            destination.expense = expenseBrain.filteredExpenses[indexPath!.row]
        }
        
        if let destination = segue.destination as? FilterViewController {
            destination.delegate = self
        }
    }
}

extension ExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseBrain.filteredExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = expenseBrain.filteredExpenses[indexPath.row].title
        cell.detailTextLabel?.text = String(expenseBrain.filteredExpenses[indexPath.row].amount)
        return cell
    }
}

extension ExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.showExpenseSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExpenseViewController: FilterViewControllerDelegate {
    func didUpdateFilters(filters: Filters) {
        print("notification from filter VC")
        expenseBrain.updateFilters(newFilters: filters)
    }
}
