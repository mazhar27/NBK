//
//  Router.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//
//

import Foundation
import Alamofire
typealias Headers = [String: String]

enum Router: URLRequestConvertible {
    case news(parameters: Parameters)
    case sources(parameters: Parameters)
    var method: HTTPMethod {
        switch self {
        case .news, .sources:
            return .get
       }
    }
   var path: String {
        switch self {
        case .news:
            return "top-headlines"
        case .sources:
            return "top-headlines/sources"
        }
    }
   // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
       let url = try Constants.API.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
     switch self {
     case .news(let parameters),
    .sources(let parameters):
         return try URLEncoding.default.encode(urlRequest, with: parameters)
       }
    }
}
