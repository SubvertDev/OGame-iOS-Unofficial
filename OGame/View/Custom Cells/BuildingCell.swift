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

enum TypeOfSupply {
    case metalMine
    case crystalMine
    case deuteriumMine
    case solarPlant
    case fusionPlant
    case metalStorage
    case crystalStorage
    case deuteriumStorage
}

enum TypeOfFacility {
    case roboticsFactory
    case shipyard
    case researchLaboratory
    case allianceDepot
    case missileSilo
    case naniteFactory
    case terraformer
    case repairDock
    case moonBase
    case sensorPhalanx
    case jumpGate
}

enum TypeOfResearch {
    case energy
    case laser
    case ion
    case hyperspace
    case plasma
    case combustionDrive
    case impulseDrive
    case hyperspaceDrive
    case espionage
    case computer
    case astrophysics
    case researchNetwork
    case graviton
    case weapons
    case shielding
    case armor
}

enum TypeOfShip {
    case lightFighter
    case heavyFighter
    case cruiser
    case battleship
    case interceptor
    case bomber
    case destroyer
    case deathstar
    case reaper
    case explorer
    case smallTransporter
    case largeTransporter
    case colonyShip
    case recycler
    case espionageProbe
    case solarSatellite
    case crawler
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
    func setSupply(type: TypeOfSupply, supplies: Supplies, _ isConstructionNow: Bool) {
        switch type {
        
        case .metalMine:
            typeOfBuilding = Buildings().metalMine
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.metalMine.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.metalMine.isPossible)! {
                buildingImage.image = UIImage(named: "unMetalMine")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "metalMine")
            }
            levelLabel.text = "\(supplies.metalMine.level)"
            buildingNameLabel.text = "Metal Mine"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .crystalMine:
            typeOfBuilding = Buildings().crystalMine
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.crystalMine.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.crystalMine.isPossible)! {
                buildingImage.image = UIImage(named: "unCrystalMine")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "crystalMine")
            }
            levelLabel.text = "\(supplies.crystalMine.level)"
            buildingNameLabel.text = "Crystal Mine"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .deuteriumMine:
            typeOfBuilding = Buildings().deuteriumMine
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.deuteriumMine.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.deuteriumMine.isPossible)! {
                buildingImage.image = UIImage(named: "unDeuteriumMine")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "deuteriumMine")
            }
            levelLabel.text = "\(supplies.deuteriumMine.level)"
            buildingNameLabel.text = "Deuterium Mine"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .solarPlant:
            typeOfBuilding = Buildings().solarPlant
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.solarPlant.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.solarPlant.isPossible)! {
                buildingImage.image = UIImage(named: "unSolarPlant")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "solarPlant")
            }
            levelLabel.text = "\(supplies.solarPlant.level)"
            buildingNameLabel.text = "Solar Plant"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .fusionPlant:
            typeOfBuilding = Buildings().fusionPlant
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.fusionPlant.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.fusionPlant.isPossible)! {
                buildingImage.image = UIImage(named: "unFusionPlant")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "fusionPlant")
            }
            levelLabel.text = "\(supplies.fusionPlant.level)"
            buildingNameLabel.text = "Fusion Plant"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .metalStorage:
            typeOfBuilding = Buildings().metalStorage
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.metalStorage.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.metalStorage.isPossible)! {
                buildingImage.image = UIImage(named: "unMetalStorage")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "metalStorage")
            }
            levelLabel.text = "\(supplies.metalStorage.level)"
            buildingNameLabel.text = "Metal Storage"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .crystalStorage:
            typeOfBuilding = Buildings().crystalStorage
            buildButton.isEnabled = isConstructionNow ? false : true
            if (supplies.crystalStorage.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.crystalStorage.isPossible)! {
                buildingImage.image = UIImage(named: "unCrystalStorage")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "crystalStorage")
            }
            levelLabel.text = "\(supplies.crystalStorage.level)"
            buildingNameLabel.text = "Crystal Storage"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium:  \(Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .deuteriumStorage:
            buildButton.isEnabled = isConstructionNow ? false : true
            typeOfBuilding = Buildings().deuteriumStorage
            if (supplies.deuteriumStorage.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(supplies.deuteriumStorage.isPossible)! {
                buildingImage.image = UIImage(named: "unDeuteriumStorage")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "deuteriumStorage")
            }
            levelLabel.text = "\(supplies.deuteriumStorage.level)"
            buildingNameLabel.text = "Deuterium Storage"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
        }
    }
    
    
    
    
    // MARK: - SET FACILITY
    func setFacility(type: TypeOfFacility, facilities: Facilities, _ isConstructionNow: Bool) {
        switch type {
        case .roboticsFactory:
            typeOfBuilding = Buildings().roboticsFactory
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.roboticsFactory.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.roboticsFactory.isPossible)! {
                buildingImage.image = UIImage(named: "unRoboticsFactory")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "roboticsFactory")
            }
            levelLabel.text = "\(facilities.roboticsFactory.level)"
            buildingNameLabel.text = "Robotics Factory"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .shipyard:
            typeOfBuilding = Buildings().shipyard
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.shipyard.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.shipyard.isPossible)! {
                buildingImage.image = UIImage(named: "unShipyard")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "shipyard")
            }
            levelLabel.text = "\(facilities.shipyard.level)"
            buildingNameLabel.text = "Shipyard"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .researchLaboratory:
            typeOfBuilding = Buildings().researchLaboratory
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.researchLaboratory.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.researchLaboratory.isPossible)! {
                buildingImage.image = UIImage(named: "unResearchLaboratory")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "researchLaboratory")
            }
            levelLabel.text = "\(facilities.researchLaboratory.level)"
            buildingNameLabel.text = "Research Laboratory"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .allianceDepot:
            typeOfBuilding = Buildings().allianceDepot
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.allianceDepot.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.allianceDepot.isPossible)! {
                buildingImage.image = UIImage(named: "unAllianceDepot")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "allianceDepot")
            }
            levelLabel.text = "\(facilities.allianceDepot.level)"
            buildingNameLabel.text = "Alliance Depot"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .missileSilo:
            typeOfBuilding = Buildings().missileSilo
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.missileSilo.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.missileSilo.isPossible)! {
                buildingImage.image = UIImage(named: "unMissileSilo")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "missileSilo")
            }
            levelLabel.text = "\(facilities.missileSilo.level)"
            buildingNameLabel.text = "Robotics Factory"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .naniteFactory:
            typeOfBuilding = Buildings().naniteFactory
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.naniteFactory.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.naniteFactory.isPossible)! {
                buildingImage.image = UIImage(named: "unNaniteFactory")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "naniteFactory")
            }
            levelLabel.text = "\(facilities.naniteFactory.level)"
            buildingNameLabel.text = "Nanite Factory"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .terraformer:
            typeOfBuilding = Buildings().terraformer
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.terraformer.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.terraformer.isPossible)! {
                buildingImage.image = UIImage(named: "unTerraformer")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "terraformer")
            }
            levelLabel.text = "\(facilities.terraformer.level)"
            buildingNameLabel.text = "Terraformer"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .repairDock:
            typeOfBuilding = Buildings().repairDock
            buildButton.isEnabled = isConstructionNow ? false : true
            if (facilities.repairDock.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(facilities.repairDock.isPossible)! {
                buildingImage.image = UIImage(named: "unRepairDock")
                buildButton.isEnabled = false
            } else {
                buildingImage.image = UIImage(named: "repairDock")
            }
            levelLabel.text = "\(facilities.repairDock.level)"
            buildingNameLabel.text = "Repair Dock"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .moonBase:
            // not implemented
            break
            
        case .sensorPhalanx:
            // not implemented
            break
            
        case .jumpGate:
            // not implemented
            break
        }
    }
    
    
    
    
    // MARK: - SET RESEARCH
    func setResearch(type: TypeOfResearch, researches: Researches, _ isConstructionNow: Bool) {
        switch type {
        
        case .energy:
            typeOfBuilding = Researchings().energy
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.energy.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.energy.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.energy
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.energy
            }
            levelLabel.text = "\(researches.energy.level)"
            buildingNameLabel.text = "Energy Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().energy, level: researches.energy.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().energy, level: researches.energy.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().energy, level: researches.energy.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .laser:
            typeOfBuilding = Researchings().laser
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.laser.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.laser.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.laser
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.laser
            }
            levelLabel.text = "\(researches.laser.level)"
            buildingNameLabel.text = "Laser Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().laser, level: researches.laser.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().laser, level: researches.laser.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().laser, level: researches.laser.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .ion:
            typeOfBuilding = Researchings().ion
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.ion.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.ion.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.ion
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.ion
            }
            levelLabel.text = "\(researches.ion.level)"
            buildingNameLabel.text = "Ion Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().ion, level: researches.ion.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().ion, level: researches.ion.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().ion, level: researches.ion.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .hyperspace:
            typeOfBuilding = Researchings().hyperspace
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.hyperspace.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.hyperspace.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.hyperspace
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.hyperspace
            }
            levelLabel.text = "\(researches.hyperspace.level)"
            buildingNameLabel.text = "Hyperspace Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .plasma:
            typeOfBuilding = Researchings().plasma
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.plasma.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.plasma.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.plasma
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.plasma
            }
            levelLabel.text = "\(researches.plasma.level)"
            buildingNameLabel.text = "Plasma Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().plasma, level: researches.plasma.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().plasma, level: researches.plasma.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().plasma, level: researches.plasma.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .combustionDrive:
            typeOfBuilding = Researchings().combustionDrive
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.combustionDrive.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.combustionDrive.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.combustionDrive
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.combustionDrive
            }
            levelLabel.text = "\(researches.combustionDrive.level)"
            buildingNameLabel.text = "Cobustion Drive"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .impulseDrive:
            typeOfBuilding = Researchings().impulseDrive
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.impulseDrive.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.impulseDrive.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.impulseDrive
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.impulseDrive
            }
            levelLabel.text = "\(researches.impulseDrive.level)"
            buildingNameLabel.text = "Impulse Drive"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .hyperspaceDrive:
            typeOfBuilding = Researchings().hyperspaceDrive
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.hyperspaceDrive.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.hyperspaceDrive.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.hyperspace
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.hyperspace
            }
            levelLabel.text = "\(researches.hyperspaceDrive.level)"
            buildingNameLabel.text = "Hyperspace Drive"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .espionage:
            typeOfBuilding = Researchings().espionage
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.espionage.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.espionage.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.espionage
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.espionage
            }
            levelLabel.text = "\(researches.espionage.level)"
            buildingNameLabel.text = "Espionage Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().espionage, level: researches.espionage.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().espionage, level: researches.espionage.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().espionage, level: researches.espionage.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .computer:
            typeOfBuilding = Researchings().computer
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.computer.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.computer.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.computer
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.computer
            }
            levelLabel.text = "\(researches.computer.level)"
            buildingNameLabel.text = "Computer Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().computer, level: researches.computer.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().computer, level: researches.computer.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().computer, level: researches.computer.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .astrophysics:
            typeOfBuilding = Researchings().astrophysics
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.astrophysics.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.astrophysics.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.astrophysics
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.astrophysics
            }
            levelLabel.text = "\(researches.astrophysics.level)"
            buildingNameLabel.text = "Astrophysics"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .researchNetwork:
            typeOfBuilding = Researchings().researchNetwork
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.researchNetwork.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.researchNetwork.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.researchNetwork
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.researchNetwork
            }
            levelLabel.text = "\(researches.researchNetwork.level)"
            buildingNameLabel.text = "Intergalactic Research Network"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .graviton:
            typeOfBuilding = Researchings().graviton
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.graviton.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.graviton.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.graviton
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.graviton
            }
            levelLabel.text = "\(researches.graviton.level)"
            buildingNameLabel.text = "Graviton Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().graviton, level: researches.graviton.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().graviton, level: researches.graviton.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().graviton, level: researches.graviton.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .weapons:
            typeOfBuilding = Researchings().weapons
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.weapons.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.weapons.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.weapons
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.weapons
            }
            levelLabel.text = "\(researches.weapons.level)"
            buildingNameLabel.text = "Weapons Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().weapons, level: researches.weapons.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().weapons, level: researches.weapons.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().weapons, level: researches.weapons.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .shielding:
            typeOfBuilding = Researchings().shielding
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.shielding.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.shielding.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.shielding
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.shielding
            }
            levelLabel.text = "\(researches.shielding.level)"
            buildingNameLabel.text = "Shielding Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().shielding, level: researches.shielding.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().shielding, level: researches.shielding.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().shielding, level: researches.shielding.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .armor:
            typeOfBuilding = Researchings().armor
            buildButton.isEnabled = isConstructionNow ? false : true
            if (researches.armor.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(researches.armor.isPossible)! {
                buildingImage.image = Images.Researches.SmallUnavailable.armor
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Researches.SmallAvailable.armor
            }
            levelLabel.text = "\(researches.armor.level)"
            buildingNameLabel.text = "Armour Technology"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Researchings().armor, level: researches.armor.level)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Researchings().armor, level: researches.armor.level)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Researchings().armor, level: researches.armor.level)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        }
    }
    
    
    // MARK: - SET SHIPS
    func setShip(type: TypeOfShip, ships: Ships, _ isConstructionNow: Bool) {
        
        amountTextField.isHidden = false
        
        switch type {
        
        case .lightFighter:
            typeOfBuilding = Shipings().lightFighter()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.lightFighter.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.lightFighter.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.lightFighter
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.lightFighter
            }
            levelLabel.text = "\(ships.allShips[0].amount)"
            buildingNameLabel.text = "Light Fighter"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .heavyFighter:
            typeOfBuilding = Shipings().heavyFighter()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.lightFighter.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.heavyFighter.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.heavyFighter
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.heavyFighter
            }
            levelLabel.text = "\(ships.allShips[1].amount)"
            buildingNameLabel.text = "Heavy Fighter"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .cruiser:
            typeOfBuilding = Shipings().cruiser()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.lightFighter.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.cruiser.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.cruiser
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.cruiser
            }
            levelLabel.text = "\(ships.allShips[2].amount)"
            buildingNameLabel.text = "Cruiser"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .battleship:
            typeOfBuilding = Shipings().battleship()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.battleship.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.battleship.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.battleship
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.battleship
            }
            levelLabel.text = "\(ships.allShips[3].amount)"
            buildingNameLabel.text = "Battleship"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .interceptor:
            //TODO: change to battlecruiser
            typeOfBuilding = Shipings().interceptor()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.interceptor.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.interceptor.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.interceptor
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.interceptor
            }
            levelLabel.text = "\(ships.allShips[4].amount)"
            buildingNameLabel.text = "Battlecruiser"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().interceptor(), level: ships.interceptor.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().interceptor(), level: ships.interceptor.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().interceptor(), level: ships.interceptor.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .bomber:
            typeOfBuilding = Shipings().bomber()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.bomber.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.bomber.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.bomber
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.bomber
            }
            levelLabel.text = "\(ships.allShips[5].amount)"
            buildingNameLabel.text = "Bomber"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .destroyer:
            typeOfBuilding = Shipings().destroyer()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.destroyer.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.destroyer.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.destroyer
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.destroyer
            }
            levelLabel.text = "\(ships.allShips[6].amount)"
            buildingNameLabel.text = "Destroyer"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .deathstar:
            typeOfBuilding = Shipings().deathstar()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.deathstar.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.deathstar.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.deathstar
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.deathstar
            }
            levelLabel.text = "\(ships.allShips[7].amount)"
            buildingNameLabel.text = "Deathstar"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .reaper:
            typeOfBuilding = Shipings().reaper()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.reaper.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.reaper.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.reaper
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.reaper
            }
            levelLabel.text = "\(ships.allShips[8].amount)"
            buildingNameLabel.text = "Reaper"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .explorer:
            // TODO: Change to pathfinder
            typeOfBuilding = Shipings().explorer()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.explorer.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.explorer.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.explorer
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.explorer
            }
            levelLabel.text = "\(ships.allShips[9].amount)"
            buildingNameLabel.text = "Pathfinder"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().explorer(), level: ships.explorer.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().explorer(), level: ships.explorer.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().explorer(), level: ships.explorer.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .smallTransporter:
            typeOfBuilding = Shipings().smallTransporter()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.smallTransporter.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.smallTransporter.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.smallTransporter
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.smallTransporter
            }
            levelLabel.text = "\(ships.allShips[10].amount)"
            buildingNameLabel.text = "Small Cargo"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().smallTransporter(), level: ships.smallTransporter.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().smallTransporter(), level: ships.smallTransporter.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().smallTransporter(), level: ships.smallTransporter.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .largeTransporter:
            typeOfBuilding = Shipings().largeTransporter()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.largeTransporter.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.largeTransporter.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.largeTransporter
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.largeTransporter
            }
            levelLabel.text = "\(ships.allShips[11].amount)"
            buildingNameLabel.text = "Large Transporter"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().largeTransporter(), level: ships.largeTransporter.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().largeTransporter(), level: ships.largeTransporter.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().largeTransporter(), level: ships.largeTransporter.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .colonyShip:
            typeOfBuilding = Shipings().colonyShip()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.colonyShip.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.colonyShip.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.colonyShip
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.colonyShip
            }
            levelLabel.text = "\(ships.allShips[12].amount)"
            buildingNameLabel.text = "Colony Ship"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .recycler:
            typeOfBuilding = Shipings().recycler()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.recycler.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.recycler.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.recycler
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.recycler
            }
            levelLabel.text = "\(ships.allShips[13].amount)"
            buildingNameLabel.text = "Recycler"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .espionageProbe:
            typeOfBuilding = Shipings().espionageProbe()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.espionageProbe.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.espionageProbe.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.espionageProbe
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.espionageProbe
            }
            levelLabel.text = "\(ships.allShips[14].amount)"
            buildingNameLabel.text = "Espionage Probe"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .solarSatellite:
            typeOfBuilding = Shipings().solarSatellite()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.solarSatellite.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.solarSatellite.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.solarSatellite
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.solarSatellite
            }
            levelLabel.text = "\(ships.allShips[15].amount)"
            buildingNameLabel.text = "Solar Satellite"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        case .crawler:
            typeOfBuilding = Shipings().crawler()
            buildButton.isEnabled = isConstructionNow ? false : true
            if (ships.crawler.inConstruction)! {
                buildingImage.image = UIImage(systemName: "timer")
            } else if !(ships.crawler.isPossible)! {
                buildingImage.image = Images.Ships.SmallUnavailable.crawler
                buildButton.isEnabled = false
            } else {
                buildingImage.image = Images.Ships.SmallAvailable.crawler
            }
            levelLabel.text = "\(ships.allShips[16].amount)"
            buildingNameLabel.text = "Crawler"
            metalRequiredLabel.text = "Metal: \(Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[0])"
            crystalRequiredLabel.text = "Crystal: \(Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[1])"
            deuteriumRequiredLabel.text = "Deuterium: \(Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[2])"
            timeToBuildLabel.text = "Time to build: N/A"
            
        }
        
    }
    
}
