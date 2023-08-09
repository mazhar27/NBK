//
//  NetworkManager.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//
//

import Foundation
import Alamofire
import Combine
import UIKit

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
}
final class NetworkManager: NetworkServiceType {
    var request: Alamofire.Request?
    let retryLimit = 1
    fileprivate var isReachable = false
    static let shared = NetworkManager()
    private var manager = NetworkReachabilityManager(host: "www.apple.com")
    private init() {}
    // MARK: - startMonitoring
    func startMonitoring() {
        self.manager?.startListening(onQueue: DispatchQueue.main,
                                     onUpdatePerforming: { (networkStatus) in
            if networkStatus == .reachable(.cellular) ||
                networkStatus == .reachable(.ethernetOrWiFi) {
                self.isReachable = true
            } else {
                self.isReachable = false
            }
        })
    }
    func isConnected() -> Bool {
        self.isReachable
    }
    // Request with sub type
    func request<T: Codable>(url: URLRequestConvertible, showLoader: Bool = true) -> Future<BaseModel<T>, NetworkError> {
        if !Connectivity.isConnectedToInternet {
            print("Not Connected")
            return Future<BaseModel<T>, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        return Future<BaseModel<T>, NetworkError> { promise in
            AF.request(url).decodable(showLoader, url.urlRequest?.url?.path ?? "") { data in
                promise(.success(data))
            } failure: { (error) in
                promise(.failure(error!))
            }
        }
    }
    func requestwithoutConvertible<T: Codable>(url: String, params: [String: Any], method: HTTPMethod, showLoader: Bool = true) -> Future<BaseModel<T>, NetworkError> {
let myURL = Constants.API.baseURL + url
        var encoding: ParameterEncoding = URLEncoding.default
        if method == .post || method == .delete {
            encoding = JSONEncoding.default
        }
        if !isConnected() {
            return Future<BaseModel<T>, NetworkError> { promise in
                promise(.failure(NetworkError.noInternet))
            }
        }
        if showLoader {CustomLoader.shared.showLoader()}
        return Future<BaseModel<T>, NetworkError> { promise in
            // Now Execute
            AF.request(URL(string: myURL)!, method: method, parameters: params, encoding: encoding).decodable(showLoader, url) { data in
                promise(.success(data))
            } failure: { (error) in
                promise(.failure(error!))
            }
        }
    }
    // Request without sub type
    func netWorkRequest<T: Codable>(url: URLRequestConvertible, showLoader: Bool = true) -> Future<T, NetworkError> {
        // Check if internet connected
        //        if !isConnected() {
        //            return Future<T, NetworkError> { promise in
        //                promise(.failure(NetworkError.noInternet))
        //            }
        //        }
        if showLoader {CustomLoader.shared.showLoader()}
        return Future<T, NetworkError> { promise in
            AF.request(url).decodableWithOutSubType(showLoader) { data in
                CustomLoader.shared.hideLoader()
                promise(.success(data))
            } failure: { (error) in
                CustomLoader.shared.hideLoader()
                promise(.failure(error!))
            }
        }
    }
}

extension Alamofire.DataRequest {
    @discardableResult
    func decodable<T: Codable>(_ showLoader: Bool, _ urlEndpoint: String, success: @escaping (BaseModel<T>) -> Swift.Void, failure: @escaping (NetworkError?) -> Swift.Void) -> Self {
        response(completionHandler: { response in
            if showLoader {
                CustomLoader.shared.hideLoader()
            }
            print(urlEndpoint)
            guard let httpResponse = response.response as HTTPURLResponse? else {
                failure(NetworkError.invalidResponse)
                return
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                if let data = response.data {
                    print("???? --- \(data)")
                    do {
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        if let message = result.message {
                            return failure(NetworkError.responseError(message: message))
                        }
                    } catch let error {
                        print("???? error --- \(data)")
                        return failure(NetworkError.jsonDecodingError(error: error.localizedDescription))
                    }
                }
                return failure(NetworkError.dataLoadingError(statusCode: httpResponse.statusCode))
            }
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(BaseModel<T>.self, from: data)
                    success(result)
               } catch let error {
                    failure(NetworkError.jsonDecodingError(error: error.localizedDescription))
                }
            }
        })
        return self
    }
    @discardableResult
    func decodableWithOutSubType<T: Codable>(_ showLoader: Bool, success: @escaping (T) -> Swift.Void,
                                             failure: @escaping (NetworkError?) -> Swift.Void) -> Self {
        response(completionHandler: { response in
            if showLoader {
                CustomLoader.shared.showLoader()
            }
            guard let httpResponse = response.response as HTTPURLResponse? else {
                failure(NetworkError.invalidResponse)
                return
            }
            guard 200..<300 ~= httpResponse.statusCode else {
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        if let message = result.message {
                            return failure(NetworkError.responseError(message: message))
                        }
                    } catch let error {
                        return failure(NetworkError.jsonDecodingError(error: error.localizedDescription))
                    }
                }
                return failure(NetworkError.dataLoadingError(statusCode: httpResponse.statusCode))
            }
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    success(result)
                } catch let error {
                    failure(NetworkError.jsonDecodingError(error: error.localizedDescription))
                }
            }
        })
        return self
    }
}
