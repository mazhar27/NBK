//
//  DashboardRepo.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//

import Foundation
import Combine

class DashboardRepo {
   //    get news summary
    static func getNewsData(country: String = "us", category: String = "business") -> Future<NewsDataModel, NetworkError> {
        let param: [String: String] = ["apiKey": UserDefaults.NewsApiKey, "country": country, "category": category]
        return NetworkManager.shared.netWorkRequest(url: Router.news(parameters: param))
        }
    static func getNewsSources() -> Future<SourcesModel, NetworkError> {
        let param: [String: String] = ["apiKey": UserDefaults.NewsApiKey]
          return NetworkManager.shared.netWorkRequest(url: Router.sources(parameters: param))
        }
}
