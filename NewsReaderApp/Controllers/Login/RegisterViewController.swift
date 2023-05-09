//
//  RegisterViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 03/05/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        emailTextField.placeholder = "Type your email"
        passwordTextField.placeholder = "Type your password"
        registerButton.layer.cornerRadius = 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.viewControllers.removeAll(where: { viewController in
            return viewController is LoginViewController
        })
    }
    
    func register() {
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlert(title: "Error", message: "Email is not valid")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "Password is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let err = error {
                strongSelf.presentAlert(title: "Error", message: err.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Congratuliations", message: "Register success!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                    strongSelf.showLoginViewController()
                }))
                strongSelf.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        register()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        showLoginViewController()
    }

}

// MARK: - presentAlert
extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - showRegisterViewController
extension LoginViewController {
    func showRegisterViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - showLoginViewController
extension RegisterViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

