//
//  ProfileViewController.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 03/05/23.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfile()
    }
    
    func setProfile() {
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            print("DisplayName...\(user.displayName ?? "NOT SET")")
            emailTextField.text = user.email
            nameTextField.text = user.displayName
        }
    }
    
    func updateProfile() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameTextField.text
        changeRequest?.commitChanges(completion: { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let err = error {
                strongSelf.presentAlert(title: "Error", message: err.localizedDescription)
            } else {
                strongSelf.presentAlert(title: "Profile Updated", message: "Successfully update your profile")
            }
        })
        
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        updateProfile()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.goToLogin()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                self.presentAlert(title: "Error", message: signOutError.localizedDescription)
            }
        }))
        
        self.present(alert, animated: true)
    }
}
