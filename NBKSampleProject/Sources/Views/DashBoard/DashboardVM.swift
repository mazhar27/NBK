//
//  DashboardVM.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//

import Foundation
import Combine

class DashboardViewModel {
    private var cancellables = Set<AnyCancellable>()
    let newsModelResults = PassthroughSubject<NewsDataModel, Error>()
    @Published private(set) var state = State.idle
    func getTopNews(country: String, category: String) {
        DashboardRepo.getNewsData(country: country, category: category)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.newsModelResults.send(completion: .failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.newsModelResults.send(result)
            }).store(in: &cancellables)
    }
}
