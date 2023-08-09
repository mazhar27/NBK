//
//  UIStoryBoard-Ext.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import Foundation
import UIKit

extension UIStoryboard {

    class func instantiateViewController <T: UIViewController>(_ type: T.Type, storyboardIdentifier: String = Storyboards.main) -> T? {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(type)
    }

    func instantiateViewController <T: UIViewController>(_ type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
