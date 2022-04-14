//
//  BuildingCell.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

protocol BuildingCellDelegate: AnyObject {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String), _ sender: UIButton)
}

enum BuildingType: Int {
    case supplies = 1
    case facilities = 2
    case research = 3
    case shipyard = 4
    case defenses = 5
}

final class BuildingCell: UITableViewCell {

    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var metalRequiredLabel: UILabel!
    @IBOutlet weak var crystalRequiredLabel: UILabel!
    @IBOutlet weak var deuteriumRequiredLabel: UILabel!
    @IBOutlet weak var timeToBuildLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var buildButton: UIButton!

    var typeOfBuilding: (Int, Int, String)?

    weak var delegate: BuildingCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        buildingImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Actions
    @IBAction func buildPressed(_ sender: UIButton) {
        delegate?.didTapButton(self, typeOfBuilding!, sender)
    }
    
    // MARK: Public
    func set(type: BuildingType, building: Building, player: PlayerData) {
        
        typeOfBuilding = (building.buildingsID, 1, "\(type)")
        buildButton.isEnabled = false
        buildingNameLabel.text = building.name
        metalRequiredLabel.text = "Metal: \(building.metal)"
        crystalRequiredLabel.text = "Crystal: \(building.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
        levelLabel.text = "\(building.levelOrAmount)"
        timeToBuildLabel.text = "\(building.timeToBuild)"
        
        switch type {
            // MARK: Supply, Facility, Research
        case .supplies, .facilities, .research:
            switch building.condition {
            case "on":
                buildingImage.image = building.image.available
                buildButton.isEnabled = true
            case "active":
                buildingImage.image = UIImage(systemName: "timer")
                levelLabel.text = "\(building.levelOrAmount) -> \(building.levelOrAmount + 1)"
                buildButton.isEnabled = player.officers.commander
            case "disabled":
                buildingImage.image = building.image.unavailable
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
          
            // MARK: Shipyard, Defences
        case .shipyard, .defenses:
            switch building.condition {
            case "on":
                buildingImage.image = building.image.available
                buildButton.isEnabled = true
            case "active":
                buildingImage.image = UIImage(systemName: "timer")
                buildButton.isEnabled = true
                // TODO: Add info about from what amount to what amount building is going
                // levelLabel.text = "\(ships.allShips[id].levelOrAmount) -> \(ships.allShips[id].levelOrAmount + 1)"
            case "disabled":
                buildingImage.image = building.image.unavailable
                buildButton.isEnabled = player.officers.commander
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
        }
    }
}
