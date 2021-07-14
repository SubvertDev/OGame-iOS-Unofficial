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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buildPressed(_ sender: UIButton) {
        delegate?.didTapButton(self, typeOfBuilding!)
    }
    
    
    // MARK: - SET SUPPLY
    func setSupply(id: Int, resourceBuildings: BuildingsData) {
        
        typeOfBuilding = (resourceBuildings[id].buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = resourceBuildings[id].name
        metalRequiredLabel.text = "Metal: \(resourceBuildings[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(resourceBuildings[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(resourceBuildings[id].deuterium)"
        levelLabel.text = "\(resourceBuildings[id].level)"
        timeToBuildLabel.text = ""
        // TODO: Hide 0 resource labels
        
        switch resourceBuildings[id].condition {
        case "on":
            buildingImage.image = resourceBuildings[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            levelLabel.text = "\(resourceBuildings[id].level) -> \(resourceBuildings[id].level + 1)"
        case "disabled":
            buildingImage.image = resourceBuildings[id].image.unavailable
        case "off":
            buildingImage.image = resourceBuildings[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET FACILITY
    func setFacility(id: Int, facilityBuildings: BuildingsData) {
                
        typeOfBuilding = (facilityBuildings[id].buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = facilityBuildings[id].name
        metalRequiredLabel.text = "Metal: \(facilityBuildings[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(facilityBuildings[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(facilityBuildings[id].deuterium)"
        levelLabel.text = "\(facilityBuildings[id].level)"
        timeToBuildLabel.text = ""
        // TODO: Hide 0 resources labels
        
        switch facilityBuildings[id].condition {
        case "on":
            buildingImage.image = facilityBuildings[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            levelLabel.text = "\(facilityBuildings[id].level) -> \(facilityBuildings[id].level + 1)"
        case "disabled":
            buildingImage.image = facilityBuildings[id].image.unavailable
        case "off":
            buildingImage.image = facilityBuildings[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET RESEARCH
    func setResearch(id: Int, researchTechnologies: ResearchesData) {
                
        typeOfBuilding = (researchTechnologies[id].buildingsID, 1, "research")
        buildButton.isEnabled = false
        buildingNameLabel.text = researchTechnologies[id].name
        metalRequiredLabel.text = "Metal: \(researchTechnologies[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(researchTechnologies[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(researchTechnologies[id].deuterium)"
        levelLabel.text = "\(researchTechnologies[id].level)"
        timeToBuildLabel.text = ""

        switch researchTechnologies[id].condition {
        case "on":
            buildingImage.image = researchTechnologies[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            levelLabel.text = "\(researchTechnologies[id].level) -> \(researchTechnologies[id].level + 1)"
        case "disabled":
            buildingImage.image = researchTechnologies[id].image.unavailable
        case "off":
            buildingImage.image = researchTechnologies[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET SHIP
    func setShip(id: Int, shipsTechnologies: ShipsData) {
                        
        typeOfBuilding = (shipsTechnologies[id].buildingsID, 1, "shipyard")
        buildButton.isEnabled = false
        buildingNameLabel.text = shipsTechnologies[id].name
        metalRequiredLabel.text = "Metal: \(shipsTechnologies[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(shipsTechnologies[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(shipsTechnologies[id].deuterium)"
        levelLabel.text = "\(shipsTechnologies[id].amount)"
        timeToBuildLabel.text = ""
        amountTextField.isHidden = false
        
        // TODO: Add building queue for ships
        // This is check to restrict from building more than one type at a time
        var shipActive = false
        for ship in shipsTechnologies {
            if ship.condition == "active" {
                shipActive = true
            }
        }
        
        switch shipsTechnologies[id].condition {
        case "on":
            if shipActive {
                buildingImage.image = shipsTechnologies[id].image.unavailable
            } else {
                buildingImage.image = shipsTechnologies[id].image.available
                buildButton.isEnabled = true
            }
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            // TODO: Add info about from what amount to what amount building is going
            //levelLabel.text = "\(ships.allShips[id].amount) -> \(ships.allShips[id].amount + 1)"
        case "disabled":
            buildingImage.image = shipsTechnologies[id].image.unavailable
        case "off":
            buildingImage.image = shipsTechnologies[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET DEFENCE
    func setDefence(id: Int, defenceTechnologies: DefencesData) {
        
        typeOfBuilding = (defenceTechnologies[id].buildingsID, 1, "defenses")
        buildButton.isEnabled = false
        buildingNameLabel.text = defenceTechnologies[id].name
        metalRequiredLabel.text = "Metal: \(defenceTechnologies[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(defenceTechnologies[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(defenceTechnologies[id].deuterium)"
        levelLabel.text = "\(defenceTechnologies[id].amount)"
        timeToBuildLabel.text = ""
        amountTextField.isHidden = false
        
        // TODO: Add building queue for defences
        // This is check to restrict from building more than one type at a time
        var defenceActive = false
        for defence in defenceTechnologies {
            if defence.condition == "active" {
                defenceActive = true
            }
        }
        
        switch defenceTechnologies[id].condition {
        case "on":
            if defenceActive {
                buildingImage.image = defenceTechnologies[id].image.unavailable
            } else {
                buildingImage.image = defenceTechnologies[id].image.available
                buildButton.isEnabled = true
            }
        case "active":
            buildingImage.image = UIImage(systemName: "timer") // TODO: Change it
            // TODO: Add info about from what amount to what amount building is going
            //levelLabel.text = "\(ships.allShips[id].amount) -> \(ships.allShips[id].amount + 1)"
        case "disabled":
            buildingImage.image = defenceTechnologies[id].image.unavailable
        case "off":
            buildingImage.image = defenceTechnologies[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
}
