//
//  CustomLoader.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//

import Foundation
import UIKit

class CustomLoader {
    static let shared = CustomLoader()
    private var overlayView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    private init() {
        // Create the overlay view
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Create the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.white
        activityIndicator.center = overlayView.center
        activityIndicator.hidesWhenStopped = true
        overlayView.addSubview(activityIndicator)
    }
    func showLoader() {
        DispatchQueue.main.async {
            if #available(iOS 15.0, *),
               let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                self.overlayView.frame = window.bounds
                window.addSubview(self.overlayView)
                self.activityIndicator.startAnimating()
            } else if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                      let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                self.overlayView.frame = window.bounds
                window.addSubview(self.overlayView)
                self.activityIndicator.startAnimating()
            }
        }
    }
func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
}
