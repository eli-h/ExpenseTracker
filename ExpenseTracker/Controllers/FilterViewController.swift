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
    @IBOutlet weak var categoryTextField: UITextField!
    
    var fromDate = 0.0
    var toDate = Date().timeIntervalSince1970
    var currentCategoryValue = "Fuel"
    var newCategories: [String] = []
    var datePickerDate = Date().timeIntervalSince1970
    
    var fromDatePicker: UIDatePicker?
    var toDatePicker: UIDatePicker?
    var categoryPicker: UIPickerView?
    var expenseBrain = ExpenseBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromDateTextField.delegate = self
        toDateTextField.delegate = self

        //Set Up Date Picker
        fromDatePicker = UIDatePicker()
        fromDatePicker?.datePickerMode = .date
        fromDatePicker?.addTarget(self, action: #selector(handleDateChange(datePicker:)), for: .valueChanged)
        fromDatePicker?.maximumDate = Date(timeIntervalSince1970: toDate)
        
        toDatePicker = UIDatePicker()
        toDatePicker?.datePickerMode = .date
        toDatePicker?.addTarget(self, action: #selector(handleDateChange(datePicker:)), for: .valueChanged)
        toDatePicker?.minimumDate = Date(timeIntervalSince1970: fromDate)
        
        let dateToolBar = UIToolbar()
        dateToolBar.sizeToFit()
        
        let dateDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped(gesture:)))
        
        dateToolBar.setItems([dateDoneButton], animated: true)
        dateToolBar.isUserInteractionEnabled = true
        
        fromDateTextField.inputView = fromDatePicker
        toDateTextField.inputView = toDatePicker

        fromDateTextField.inputAccessoryView = dateToolBar
        toDateTextField.inputAccessoryView = dateToolBar
        
        //Set Up Category Picker
        categoryPicker = UIPickerView()
        categoryPicker?.delegate = self
        categoryPicker?.dataSource = self
        
        let categoryToolBar = UIToolbar()
        categoryToolBar.sizeToFit()
        
        let categoryDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped(gesture:)))
        let categorySelectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTapped(gesture:)))
        
        categoryToolBar.setItems([categoryDoneButton, categorySelectButton], animated: true)
        categoryToolBar.isUserInteractionEnabled = true

        categoryTextField.inputAccessoryView = categoryToolBar
        categoryTextField.inputView = categoryPicker
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func doneTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func selectTapped(gesture: UITapGestureRecognizer) {
        
        if newCategories.contains(currentCategoryValue) {
            newCategories = newCategories.filter { $0 != currentCategoryValue }
        } else {
            newCategories.append(currentCategoryValue)
        }
        
        categoryTextField.text = newCategories.joined(separator: ",")
    }
    
    @objc func handleDateChange(datePicker: UIDatePicker) {
        datePickerDate = datePicker.date.timeIntervalSince1970
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        let filters = Filters(fromDate: fromDate, toDate: toDate, categories: newCategories)
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

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        let rowText = expenseBrain.categories[row]
        currentCategoryValue = rowText
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            fromDate = datePickerDate
            fromDateTextField.text = expenseBrain.formatDate(date: fromDate)
            toDatePicker?.minimumDate = Date(timeIntervalSince1970: fromDate)
        } else {
            toDate = datePickerDate
            toDateTextField.text = expenseBrain.formatDate(date: toDate)
            fromDatePicker?.maximumDate = Date(timeIntervalSince1970: toDate)
        }
        
        return true
    }
}
