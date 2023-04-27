//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 27/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.placeholder = "Type your email"
        passwordTxtField.placeholder = "Type your password"
        loginBtn.layer.cornerRadius = 6
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        print("Hello world")
    }
}

