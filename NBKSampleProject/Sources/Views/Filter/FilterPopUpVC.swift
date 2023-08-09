//
//  FilterPopUpVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import UIKit
import Combine

class FilterPopUpVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterTbvu: UITableView!
    // MARK: - Variables
    var selectedRowInSection = [Int?](repeating: nil, count: 2)
    let viewModel =  FiltersViewModel()
    private var bindings = Set<AnyCancellable>()
    var filteredCountries = [String]()
    var filteredCategories = [String]()
    private var filterTitles = ["Select Category", "Select Country"]
    weak var delegate: filtersDataDelegate?
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTableView()
        bindViewModel()
        viewModel.getAllSources()
    }
    private func initialSetup() {
        self.view.accessibilityIdentifier = "filterPopup"
        self.definesPresentationContext = true
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
    }
    private func setupTableView() {
        let nib = UINib(nibName: "FilterTVC", bundle: nil)
        filterTbvu.register(nib, forCellReuseIdentifier: "FilterTVC")
        filterTbvu.delegate = self
        filterTbvu.dataSource = self
    }
    private func bindViewModel() {
        viewModel.sourcesModelResults
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] sources in
                guard let self = self else { return }
                if let sources = sources.sources {
                    self.viewModel.filterData(data: sources)
                    self.filteredCountries = self.viewModel.filteredCountries
                    self.filteredCategories = self.viewModel.filteredCategories
                    self.filterTbvu.reloadData()
                }
            }.store(in: &bindings)
    }
  @IBAction func okBtnTpd(_ sender: Any) {
        let (selectedCategory, selectedCountry) = getSelctedCategoryCountry()
      delegate?.sendData(country: selectedCountry, category: selectedCategory)
        self.dismiss(animated: true)
    }
    private func getSelctedCategoryCountry() -> (String?, String?) {
        var selectedCountry: String?
        var selectedCategory: String?
        if let countryIndex = selectedRowInSection[1] {
            selectedCountry = filteredCountries[countryIndex]
        }
        if let categoryIndex = selectedRowInSection[0] {
            selectedCategory = filteredCategories[categoryIndex]
        }
        return (selectedCategory, selectedCountry)
     }
}

// MARK: - UITableView Delegate

extension FilterPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? filteredCategories.count : filteredCountries.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterTitles[section]
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTVC", for: indexPath) as? FilterTVC
        guard let cell = cell else {return UITableViewCell()}
        cell.configureCell(section: indexPath.section, data: indexPath.section == 0 ? filteredCategories[indexPath.row] : filteredCountries[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Adjust the height as needed
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row to remove the highlight
        tableView.deselectRow(at: indexPath, animated: true)
        // Check if the cell already has an accessory type, toggle it
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selectedRowInSection[indexPath.section] = nil
            } else {
                // Deselect the previous selected row in the section
                if let previousSelectedRow = selectedRowInSection[indexPath.section] {
                    tableView.cellForRow(at: IndexPath(row: previousSelectedRow, section: indexPath.section))?.accessoryType = .none
                }
                cell.accessoryType = .checkmark
                selectedRowInSection[indexPath.section] = indexPath.row
                print(selectedRowInSection)
            }
        }
    }
}
