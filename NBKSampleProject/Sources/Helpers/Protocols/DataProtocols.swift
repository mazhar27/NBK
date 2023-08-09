//
//  DataProtocols.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import Foundation

protocol filtersDataDelegate: AnyObject {
    func sendData(country: String?, category: String?)
}
