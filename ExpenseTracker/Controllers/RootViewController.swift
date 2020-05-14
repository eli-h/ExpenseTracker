//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit
import SQLite

class RootViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var passcodeCount: Int = 0
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passcodeCount = databaseManager.getPasscodeCount(path: K.dbFilePath)
        
        if(passcodeCount == 0) {
            showPasswordAlert()
        } else {
            updateUI()
        }
        
        print("there are \(passcodeCount) passcodes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passcodeCount = databaseManager.getPasscodeCount(path: K.dbFilePath)
        if(passcodeCount == 0) {
            showPasswordAlert()
        }
    }
    
    func updateUI() {
        passcodeTextField.placeholder = "Enter Passcode"
        loginButton.setTitle("Login", for: .normal)
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "Hey", message: "You haven't set a password yet, yould you like to?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: K.goToExpenseSegue, sender: self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if passcodeCount == 0 {
            if let newPasscode = passcodeTextField.text {
                databaseManager.createPassword(path: K.dbFilePath, newPasscode: newPasscode)
                passcodeTextField.text = ""
                self.performSegue(withIdentifier: K.goToExpenseSegue, sender: self)
            }
        } else {
            let validLogin = databaseManager.validateLogin(path: K.dbFilePath, enteredPasscode: passcodeTextField.text ?? "")
            if validLogin {
                passcodeTextField.text = ""
                errorLabel.isHidden = true

                self.performSegue(withIdentifier: K.goToExpenseSegue, sender: self)
            } else {
                errorLabel.isHidden = false
            }
        }
    }
}

