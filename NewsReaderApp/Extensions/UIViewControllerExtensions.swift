//
//  UIViewControllerExtensions.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 03/05/23.
//

import Foundation
import UIKit

extension UIViewController {
    func goToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "main_home")
        let window = UIApplication.shared.window
        window.rootViewController = viewController
    }
    
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "navLogin")
        let window = UIApplication.shared.window
        window.rootViewController = viewController
    }
}
