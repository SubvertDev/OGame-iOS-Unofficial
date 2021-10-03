//
//  GalaxyCell.swift
//  OGame
//
//  Created by Subvert on 02.08.2021.
//

import UIKit

class GalaxyCell: UITableViewCell {

    @IBOutlet weak var planetPositionLabel: UILabel!
    @IBOutlet weak var planetImage: UIImageView!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var allianceNameLabel: UILabel!
    @IBOutlet weak var espionageButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var buddyRequestButton: UIButton!
    @IBOutlet weak var missileAttackButton: UIButton!
    @IBOutlet var allButtons: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func set(with systemInfo: [Position?], indexPath: IndexPath) {
        if systemInfo[indexPath.row] != nil {
            planetPositionLabel.text = "\(indexPath.row + 1)"
            planetImage.image = UIImage(named: "\(systemInfo[indexPath.row]!.imageString)")
            planetNameLabel.text = "\(systemInfo[indexPath.row]!.planetName)"
            playerNameLabel.text = "\(systemInfo[indexPath.row]!.playerName) (\(systemInfo[indexPath.row]!.status))"
            allianceNameLabel.text = "\(systemInfo[indexPath.row]!.alliance ?? "")"
            allButtons.forEach { button in button.isHidden = false }
        } else {
            planetPositionLabel.text = "\(indexPath.row + 1)"
            planetImage.image = nil
            planetNameLabel.text = ""
            playerNameLabel.text = ""
            allianceNameLabel.text = ""
            allButtons.forEach { button in button.isHidden = true }
        }
    }
}
