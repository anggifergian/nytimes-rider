//
//  UIApplicationExtensions.swift
//  NewsReaderApp
//
//  Created by Anggi Fergian on 03/05/23.
//

import Foundation
import UIKit

extension UIApplication {
    var window: UIWindow {
        if #available(iOS 13.0, *) {
            let windowScene = connectedScenes.first as! UIWindowScene
            return windowScene.windows.first!
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
}
