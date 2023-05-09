//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 27/04/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        emailTxtField.placeholder = "Type your email"
        passwordTxtField.placeholder = "Type your password"
        loginBtn.layer.cornerRadius = 6
        
        if Auth.auth().currentUser != nil {
            goToMain()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.viewControllers.removeAll(where: { viewController in
            return viewController is RegisterViewController
        })
    }
    
    func login() {
        guard let email = emailTxtField.text, !email.isEmpty else {
            self.presentAlert(title: "Error", message: "Email can not empty!")
            return
        }
        
        guard let password = passwordTxtField.text, !password.isEmpty else {
            self.presentAlert(title: "Error", message: "Password can not empty!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let err = error {
                strongSelf.presentAlert(title: "Error", message: err.localizedDescription)
            } else {
                strongSelf.goToMain()
            }
        }
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        login()
    }
    
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        showRegisterViewController()
    }
}

