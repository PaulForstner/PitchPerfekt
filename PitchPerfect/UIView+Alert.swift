//
//  UIView+Alert.swift
//  PitchPerfect
//
//  Created by Paul Forstner on 05.05.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
