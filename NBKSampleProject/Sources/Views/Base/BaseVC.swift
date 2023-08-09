//
//  BaseVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigtionBarItems()
        // Do any additional setup after loading the view.
    }
    fileprivate func setNavigtionBarItems() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor.appThemeColor
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
       } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = UIColor.appThemeColor
        }
    }
}

extension BaseVC {
  func addLeftBarButtonItem(name: String = "backIcon") {
        let button = createButton(imageNamed: name)
        button.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        let backButtonItem  = UIBarButtonItem(customView: button)
       //        if Localize.currentLanguage() == "ar" {
        //            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        //        }else{
        //            button.transform = .identity
        //        }
      self.navigationItem.leftBarButtonItem = backButtonItem
    }
    func addRightBarButtonItems(disabledNotif: Bool = false) {
      let cartbutton = createButton(imageNamed: "filterIcon")
       cartbutton.addTarget(self, action: #selector(btnFilterAction), for: .touchUpInside)
        let cartbuttonButtonItem  = UIBarButtonItem(customView: cartbutton)
        self.navigationItem.rightBarButtonItems = [cartbuttonButtonItem]
    }
   func addRightBarButtonItem(imageName: String) {
       let rightbutton = createButton(imageNamed: imageName)
        rightbutton.addTarget(self, action: #selector(rightBarButtonAction), for: .touchUpInside)
        let rightButtonItem  = UIBarButtonItem(customView: rightbutton)
        self.navigationItem.rightBarButtonItems = [rightButtonItem]
    }
     private func createButton(imageNamed: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageNamed), for: .normal)
         if #available(iOS 15.0, *) {
             let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
             button.configuration?.contentInsets = contentInsets
         } else {
             button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         }
        return button
    }
    @objc func btnBackAction() {
        navigationController?.popViewController(animated: true)
    }
    @objc func rightBarButtonAction() {
        print("right bar button tapped")
    }
    @objc func btnFilterAction() {
    }
}
