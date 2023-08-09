//
//  UIImage-Ext.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import Foundation
import UIKit
import SDWebImage
extension UIImageView {
    func load(url: URL, placeholderImageName: String) {
        if let placeholderImage = UIImage(named: placeholderImageName) {
            self.image = placeholderImage
        }
        self.sd_setImage(with: url) { [weak self] (image, _, _, _) in
            if image == nil {
                self?.image = UIImage(named: placeholderImageName)
            }
        }
    }
}
