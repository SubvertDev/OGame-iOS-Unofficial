//
//  Buildingswift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

protocol BuildingCellDelegate: AnyObject {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String))
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
    @IBOutlet weak var amountTextField: UITextField!

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
        delegate?.didTapButton(self, typeOfBuilding!)
    }

    // MARK: - SET SUPPLY
    func setSupply(id: Int, resourceBuildings: BuildingsData) {
        let supply = resourceBuildings[id]

        typeOfBuilding = (supply.buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = supply.name
        metalRequiredLabel.text = "Metal: \(supply.metal)"
        crystalRequiredLabel.text = "Crystal: \(supply.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(supply.deuterium)"
        levelLabel.text = "\(supply.level)"
        timeToBuildLabel.text = ""
        // TODO: Hide 0 resources labels

        switch supply.condition {
        case "on":
            buildingImage.image = supply.image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            levelLabel.text = "\(supply.level) -> \(supply.level + 1)"
        case "disabled":
            buildingImage.image = supply.image.unavailable
        case "off":
            buildingImage.image = supply.image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }

    // MARK: - SET FACILITY
    func setFacility(id: Int, facilityBuildings: BuildingsData) {
        let facility = facilityBuildings[id]

        typeOfBuilding = (facility.buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = facility.name
        metalRequiredLabel.text = "Metal: \(facility.metal)"
        crystalRequiredLabel.text = "Crystal: \(facility.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(facility.deuterium)"
        levelLabel.text = "\(facility.level)"
        timeToBuildLabel.text = ""
        // TODO: Hide 0 resources labels

        switch facility.condition {
        case "on":
            buildingImage.image = facility.image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            levelLabel.text = "\(facility.level) -> \(facility.level + 1)"
        case "disabled":
            buildingImage.image = facility.image.unavailable
        case "off":
            buildingImage.image = facility.image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }

    // MARK: - SET RESEARCH
    func setResearch(id: Int, researchTechnologies: ResearchesData) {
        let research = researchTechnologies[id]

        typeOfBuilding = (research.buildingsID, 1, "research")
        buildButton.isEnabled = false
        buildingNameLabel.text = research.name
        metalRequiredLabel.text = "Metal: \(research.metal)"
        crystalRequiredLabel.text = "Crystal: \(research.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(research.deuterium)"
        levelLabel.text = "\(research.level)"
        timeToBuildLabel.text = ""

        switch research.condition {
        case "on":
            buildingImage.image = research.image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer")
            levelLabel.text = "\(research.level) -> \(research.level + 1)"
        case "disabled":
            buildingImage.image = research.image.unavailable
        case "off":
            buildingImage.image = research.image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }

    // MARK: - SET SHIP
    func setShip(id: Int, shipsTechnologies: ShipsData) {
        let ship = shipsTechnologies[id]

        typeOfBuilding = (ship.buildingsID, 1, "shipyard")
        buildButton.isEnabled = false
        buildingNameLabel.text = ship.name
        metalRequiredLabel.text = "Metal: \(ship.metal)"
        crystalRequiredLabel.text = "Crystal: \(ship.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(ship.deuterium)"
        levelLabel.text = "\(ship.amount)"
        timeToBuildLabel.text = ""
        amountTextField.isHidden = false

        // TODO: Add building queue for ships
        // This is check to restrict from building more than one type at a time
        var shipActive = false
        for ship in shipsTechnologies where ship.condition == "active" {
            shipActive = true
        }

        switch ship.condition {
        case "on":
            if shipActive {
                buildingImage.image = ship.image.unavailable
            } else {
                buildingImage.image = ship.image.available
                buildButton.isEnabled = true
            }
        case "active":
            buildingImage.image = UIImage(systemName: "timer")
            // TODO: Add info about from what amount to what amount building is going
            // levelLabel.text = "\(ships.allShips[id].amount) -> \(ships.allShips[id].amount + 1)"
        case "disabled":
            buildingImage.image = ship.image.unavailable
        case "off":
            buildingImage.image = ship.image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }

    // MARK: - SET DEFENCE
    func setDefence(id: Int, defenceTechnologies: DefencesData) {
        let defence = defenceTechnologies[id]

        typeOfBuilding = (defence.buildingsID, 1, "defenses")
        buildButton.isEnabled = false
        buildingNameLabel.text = defence.name
        metalRequiredLabel.text = "Metal: \(defence.metal)"
        crystalRequiredLabel.text = "Crystal: \(defence.crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(defence.deuterium)"
        levelLabel.text = "\(defence.amount)"
        timeToBuildLabel.text = ""
        amountTextField.isHidden = false

        // TODO: Add building queue for defences
        // This is check to restrict from building more than one type at a time
        var defenceActive = false
        for defence in defenceTechnologies where defence.condition == "active" {
            defenceActive = true
        }
        // TODO: Also connect ships
        switch defence.condition {
        case "on":
            if defenceActive {
                buildingImage.image = defence.image.unavailable
            } else {
                buildingImage.image = defence.image.available
                buildButton.isEnabled = true
            }
        case "active":
            buildingImage.image = UIImage(systemName: "timer")
            // TODO: Add info about from what amount to what amount building is going
            // levelLabel.text = "\(ships.allShips[id].amount) -> \(ships.allShips[id].amount + 1)"
        case "disabled":
            buildingImage.image = defence.image.unavailable
        case "off":
            buildingImage.image = defence.image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
}
