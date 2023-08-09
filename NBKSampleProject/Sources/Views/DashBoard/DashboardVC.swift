//
//  DashboardVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//

import UIKit
import Combine

class DashboardVC: BaseVC {
    // MARK: - IBOutlets
   @IBOutlet weak var newsTbvu: UITableView!
    // MARK: - Variables
   private let viewModel =  DashboardViewModel()
    private var bindings = Set<AnyCancellable>()
    private var articlesModelData = [Articles]()
    // MARK: - UIViewController life cycle methods
   override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButtonItems()
        setuAccessibilityIdentifiers()
        setupTableView()
        self.bindViewModel()
        viewModel.getTopNews(country: "us", category: "business")
        // Do any additional setup after loading the view.
    }
    override func btnFilterAction() {
        gotoFilterView()
    }
    private func setuAccessibilityIdentifiers() {
        self.title = "All News"
        self.view.accessibilityIdentifier = "dashboardvc"
        newsTbvu.accessibilityIdentifier = "newsTableView"
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "filterButton"
    }
    private func setupTableView() {
        let nib = UINib(nibName: "newsTVC", bundle: nil)
        newsTbvu.register(nib, forCellReuseIdentifier: "newsTVC")
        newsTbvu.delegate = self
        newsTbvu.dataSource = self
    }
    private func bindViewModel() {
        viewModel.newsModelResults
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] news in
                if let articles = news.articles {
                    self?.articlesModelData = articles
                    self?.newsTbvu.reloadData()
                }
                print(news)
            }.store(in: &bindings)
    }
   private func gotoFilterView() {
        let storyboard = getMainStoryboard()
        guard let filterVC = storyboard.instantiateViewController(FilterPopUpVC.self) else {
            return
        }
        filterVC.view.accessibilityIdentifier = "filterPopup"
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.modalTransitionStyle = .coverVertical
        filterVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        filterVC.delegate = self
        present(filterVC, animated: true)
    }
    private func gotoDescriptionView(index: Int) {
        let storyboard = getMainStoryboard()
        guard let descVC = storyboard.instantiateViewController(NewsDescriptionVC.self) else {
            return
        }
       descVC.articleData = articlesModelData[index]
        descVC.view.accessibilityIdentifier = "newsDescriptionScreen"
        self.navigationController?.pushViewController(descVC, animated: true)
    }
    func getMainStoryboard() -> UIStoryboard {
        UIStoryboard(name: Storyboards.main, bundle: nil)
    }
}

// MARK: - UITableView Delegate
extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesModelData.count
    }
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTVC", for: indexPath) as? newsTVC
    guard let cell = cell else {return UITableViewCell()}
        cell.configureCell(data: articlesModelData[indexPath.row])
        cell.accessibilityIdentifier = "newsTableViewCell"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoDescriptionView(index: indexPath.row)
    }
    }
// MARK: - Other Delegate
extension DashboardVC: filtersDataDelegate {
    func sendData(country: String?, category: String?) {
        if country != nil || category != nil {
            viewModel.getTopNews(country: country ?? "us", category: category ?? "business")
            category != nil ?(self.title = category):(self.title = "All News")
        }
    }
}
