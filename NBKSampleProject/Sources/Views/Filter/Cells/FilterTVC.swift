//
//  FilterTVC.swift
//  NKBSampleProject
//
//  Created by Mazhar HUSAIN on 04/08/2023.
//

import UIKit

class FilterTVC: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(section: Int, data: String) {
        if section == 0 {
            titleLbl.text = data
        } else {
            titleLbl.text = countryName(from: data)
        }
    }
    func countryName(from countryCode: String) -> String {
        let locale = Locale.current
        if let name = locale.localizedString(forRegionCode: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found, return the country code
            return countryCode
        }
    }
}
