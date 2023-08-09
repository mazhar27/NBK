//
//  UIViewController-Ext.swift
//  NKBSampleProject
//
//  Created by Mazhar on 2023-08-06.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, okActionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            okActionHandler?(action) // Call the handler when "OK" is tapped
            alertController.dismiss(animated: true, completion: nil) // Dismiss the alert
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
