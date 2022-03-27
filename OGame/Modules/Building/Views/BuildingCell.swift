//
//  Buildingswift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

protocol BuildingCellDelegate: AnyObject {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String), _ sender: UIButton)
}

enum BuildingType: Int {
    case supply = 1
    case facility = 2
    case research = 3
    case shipyard = 4
    case defence = 5
}

class BuildingCell: UITableViewCell {

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

    @IBAction func buildPressed(_ sender: UIButton) {
        delegate?.didTapButton(self, typeOfBuilding!, sender)
    }
    
    func set(type: BuildingType, building: Building, playerData: PlayerData) {
        switch type {
            // MARK: - Supply
        case .supply:
            typeOfBuilding = (building.buildingsID, 1, "supplies")
            buildButton.isEnabled = false
            buildingNameLabel.text = building.name
            metalRequiredLabel.text = "Metal: \(building.metal)"
            crystalRequiredLabel.text = "Crystal: \(building.crystal)"
            deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
            levelLabel.text = "\(building.levelOrAmount)"
            timeToBuildLabel.text = "\(building.timeToBuild)"

            switch building.condition {
            case "on":
                buildingImage.image = building.image.available
                buildButton.isEnabled = true
            case "active":
                buildingImage.image = UIImage(systemName: "timer")
                levelLabel.text = "\(building.levelOrAmount) -> \(building.levelOrAmount + 1)"
                buildButton.isEnabled = playerData.commander
            case "disabled":
                buildingImage.image = building.image.unavailable
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
            
            // MARK: - Facility
        case .facility:
            typeOfBuilding = (building.buildingsID, 1, "facilities")
            buildButton.isEnabled = false
            buildingNameLabel.text = building.name
            metalRequiredLabel.text = "Metal: \(building.metal)"
            crystalRequiredLabel.text = "Crystal: \(building.crystal)"
            deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
            levelLabel.text = "\(building.levelOrAmount)"
            timeToBuildLabel.text = "\(building.timeToBuild)"

            switch building.condition {
            case "on":
                buildingImage.image = building.image.available
                buildButton.isEnabled = true
            case "active":
                buildingImage.image = UIImage(systemName: "timer")
                levelLabel.text = "\(building.levelOrAmount) -> \(building.levelOrAmount + 1)"
                buildButton.isEnabled = playerData.commander
            case "disabled":
                buildingImage.image = building.image.unavailable
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
            
            // MARK: - Research
        case .research:
            typeOfBuilding = (building.buildingsID, 1, "research")
            buildButton.isEnabled = false
            buildingNameLabel.text = building.name
            metalRequiredLabel.text = "Metal: \(building.metal)"
            crystalRequiredLabel.text = "Crystal: \(building.crystal)"
            deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
            levelLabel.text = "\(building.levelOrAmount)"
            timeToBuildLabel.text = "\(building.timeToBuild)"

            switch building.condition {
            case "on":
                buildingImage.image = building.image.available
                buildButton.isEnabled = true
            case "active":
                buildingImage.image = UIImage(systemName: "timer")
                levelLabel.text = "\(building.levelOrAmount) -> \(building.levelOrAmount + 1)"
                buildButton.isEnabled = playerData.commander
            case "disabled":
                buildingImage.image = building.image.unavailable
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
            
            // MARK: - Shipyard
        case .shipyard:
            typeOfBuilding = (building.buildingsID, 1, "shipyard")
            buildButton.isEnabled = false
            buildingNameLabel.text = building.name
            metalRequiredLabel.text = "Metal: \(building.metal)"
            crystalRequiredLabel.text = "Crystal: \(building.crystal)"
            deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
            levelLabel.text = "\(building.levelOrAmount)"
            timeToBuildLabel.text = "\(building.timeToBuild)"

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
                buildButton.isEnabled = playerData.commander
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
            
            // MARK: - Defence
        case .defence:
            typeOfBuilding = (building.buildingsID, 1, "defenses")
            buildButton.isEnabled = false
            buildingNameLabel.text = building.name
            metalRequiredLabel.text = "Metal: \(building.metal)"
            crystalRequiredLabel.text = "Crystal: \(building.crystal)"
            deuteriumRequiredLabel.text = "Deuterium: \(building.deuterium)"
            levelLabel.text = "\(building.levelOrAmount)"
            timeToBuildLabel.text = "\(building.timeToBuild)"

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
                buildButton.isEnabled = playerData.commander
            case "off":
                buildingImage.image = building.image.disabled
            default:
                buildingImage.image = UIImage(systemName: "xmark")
            }
        }
    }
}
