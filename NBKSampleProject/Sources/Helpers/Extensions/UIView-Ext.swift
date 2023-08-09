//
//  UIView-Ext.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import Foundation
import UIKit
extension UIView {
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
