//
//  FilterViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-14.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func didUpdateFilters(filters: Filters)
}

class FilterViewController: UIViewController {
    
    var delegate: FilterViewControllerDelegate?

    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    
    var fromDate = 0.0
    var toDate = Date().timeIntervalSince1970
    var datePickerDate = Date().timeIntervalSince1970
    var datePicker: UIDatePicker?
    
    var expenseBrain = ExpenseBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromDateTextField.delegate = self
        toDateTextField.delegate = self

        //Set Up Date Picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(handleDateChange(datePicker:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneTapped(gesture:)))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        fromDateTextField.inputAccessoryView = toolBar
        fromDateTextField.inputView = datePicker
        toDateTextField.inputAccessoryView = toolBar
        toDateTextField.inputView = datePicker
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func doneTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func handleDateChange(datePicker: UIDatePicker) {
        datePickerDate = datePicker.date.timeIntervalSince1970
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let filters = Filters(fromDate: fromDate, toDate: toDate, categories: [])
        delegate?.didUpdateFilters(filters: filters)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.updateExpenseTableNotification), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        fromDate = 0.0
        fromDateTextField.text = ""
        toDate = Date().timeIntervalSince1970
        toDateTextField.text = ""
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            fromDate = datePickerDate
            fromDateTextField.text = expenseBrain.formatDate(date: fromDate)
        } else {
            toDate = datePickerDate
            toDateTextField.text = expenseBrain.formatDate(date: toDate)
        }
        
        return true
    }
}

