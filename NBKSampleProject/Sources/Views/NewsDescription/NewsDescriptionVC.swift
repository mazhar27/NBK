//
//  NewsDescriptionVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import UIKit

class NewsDescriptionVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionTxtVu: UITextView!
    @IBOutlet weak var thumbNailImgVu: UIImageView!
    // MARK: - Variables
    var articleData: Articles?
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    private func setupViews() {
        outerVu.setCornerRadius(12)
        descriptionTxtVu.isUserInteractionEnabled = false
        if let imageUrl = URL(string: articleData?.urlToImage ?? "") {
            thumbNailImgVu.load(url: imageUrl, placeholderImageName: "placeholder")
        }
        titleLbl.text = articleData?.title
        descriptionTxtVu.text = articleData?.description
        authorLbl.text = articleData?.author
    }
}
