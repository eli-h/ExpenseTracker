//
//  LogInViewController.swift
//  ExpenseTracker
//
//  Created by eli heineman on 2020-05-13.
//  Copyright © 2020 eli heineman. All rights reserved.
//

import UIKit
import SQLite3

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func logInPressed(_ sender: Any) {
        performSegue(withIdentifier: K.logInSegue, sender: self)
    }
}
