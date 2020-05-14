//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
        
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var categoryPicker = UIPickerView()
    
    var expense = Expense(title: "", amount: 0.0, date: Date().timeIntervalSince1970, category: "", notes: "")
    var expenseBrain = ExpenseBrain()
    
    var newTitle = ""
    var newAmount = ""
    var newDate = Date().timeIntervalSince1970
    var newCategory = ""
    var newNote = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Up Text Fields
        titleTextField.delegate = self
        amountTextField.delegate = self
        configureTapGesture()
        
        //Set Up Date Picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(handleDateChange(datePicker:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneTapped(gesture:)))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        
        //Set Up Category Picker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.inputView = categoryPicker
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func doneTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleDateChange(datePicker: UIDatePicker) {
        newDate = datePicker.date.timeIntervalSince1970
        dateTextField.text = expenseBrain.formatDate(date: newDate)
    }
    
    @IBAction func addExpensePressed(_ sender: Any) {
        if newAmount != "" && newTitle != "" && newCategory != "" {
            let newAmountDouble = Double(newAmount)!
            expense = Expense(title: newTitle, amount: newAmountDouble, date: newDate, category: newCategory, notes: newNote)
            
            let databaseManager = DatabaseManager()
            databaseManager.addExpenseToDb(path: K.dbFilePath, expense: expense)
            
            dismiss(animated: true, completion: nil)
        }
    }
}

extension AddExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseBrain.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseBrain.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = expenseBrain.categories[row]
        newCategory = categoryTextField.text!
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            newTitle = textField.text ?? ""
        } else if textField.tag == 1 {
            var numDouble = 0.0
            var formattedNum = ""
            
            if let num = textField.text {
                numDouble = Double(num)!
                formattedNum = String(format: "%.2f", numDouble)
            }
            
            textField.text = formattedNum
            newAmount = formattedNum
            
        } else if textField.tag == 4 {
            newNote = textField.text ?? ""
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
