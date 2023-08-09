//
//  FiltersViewModel.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import Foundation

import Combine

class FiltersViewModel {
    private var cancellables = Set<AnyCancellable>()
    let sourcesModelResults = PassthroughSubject<SourcesModel, Error>()
    var filteredCountries = [String]()
    var filteredCategories = [String]()
    func getAllSources() {
        DashboardRepo.getNewsSources()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.sourcesModelResults.send(completion: .failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.sourcesModelResults.send(result)
            }).store(in: &cancellables)
    }
    func filterData(data: [Sources]) {
        let uniqueCountries = Set(data.compactMap { $0.country })
        filteredCountries = Array(uniqueCountries)
        let uniqueCategories = Set(data.compactMap { $0.category })
        filteredCategories = Array(uniqueCategories)
    }
}
