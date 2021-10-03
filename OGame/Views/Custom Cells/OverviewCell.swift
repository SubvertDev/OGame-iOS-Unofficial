//
//  OverviewCell.swift
//  OGame
//
//  Created by Subvert on 02.10.2021.
//

import UIKit

class OverviewCell: UITableViewCell {

    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var upgradeLevel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(name: String, level: String, type: OverviewType) {
        buildingName.text = name
        buildingImage.image = UIImage(named: name.lowerCamelCased)

        switch type {
        case .resourcesAndFacilities:
            upgradeLevel.text = "Improve to: \(level)"
        case .researches:
            upgradeLevel.text = "Research to: \(level)"
        case .shipyardAndDefences:
            upgradeLevel.text = "Build amount: \(level)"
        }
    }
}

enum OverviewType {
    case resourcesAndFacilities
    case researches
    case shipyardAndDefences
}