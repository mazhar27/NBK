//
//  Enums.swift
//  NKBSampleProject
//
//  Created by Mazhar on 2023-08-06.
//

import Foundation
enum State {
    case idle
    case loading
    case loaded(String)
    case noInternet(String)
    case error(String)
}
