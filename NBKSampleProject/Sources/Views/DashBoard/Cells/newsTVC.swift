//
//  newsTVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 03/08/2023.
//

import UIKit

class newsTVC: UITableViewCell {

    @IBOutlet weak var thumbnailImgVu: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.setCornerRadius(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(data: Articles) {
        channelNameLbl.text = data.author
        headingLbl.text = data.title
        if let imageUrl = URL(string: data.urlToImage ?? "") {
            thumbnailImgVu.load(url: imageUrl, placeholderImageName: "placeholder")
        }
    }
}
