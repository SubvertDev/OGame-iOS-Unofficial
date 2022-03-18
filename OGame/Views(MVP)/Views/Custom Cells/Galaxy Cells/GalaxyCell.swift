//
//  GalaxyCell.swift
//  OGame
//
//  Created by Subvert on 02.08.2021.
//

import UIKit

final class GalaxyCell: UITableViewCell {

    @IBOutlet weak var planetPositionLabel: UILabel!
    @IBOutlet weak var planetImage: UIImageView!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var allianceNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(with systemInfo: [Position?], indexPath: IndexPath) {
        let position = systemInfo[indexPath.row]
        if let position = position {
            planetPositionLabel.text = "\(indexPath.row + 1)"
            planetImage.image = UIImage(named: "\(position.imageString)")
            planetNameLabel.text = "\(position.planetName)"
            playerNameLabel.text = "\(position.playerName) (\(position.status)) (\(position.rank))"
            allianceNameLabel.text = "\(position.alliance ?? "")"
        } else {
            planetPositionLabel.text = "\(indexPath.row + 1)"
            planetImage.image = nil
            planetNameLabel.text = ""
            playerNameLabel.text = ""
            allianceNameLabel.text = ""
        }
    }
}
