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
    func setSupply(id: Int, supplies: Supplies) {
        
        //TODO: Move all variables out of function
        let metalMine = (name: "Metal Mine",
                         metal: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[0],
                         crystal: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[1],
                         deuterium: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[2],
                         image: (available: Images.Resources.SmallAvailable.metalMine,
                                 unavailable: Images.Resources.SmallUnavailable.metalMine,
                                 disabled: Images.Resources.SmallDisabled.metalMine),
                         buildingsID: 1)
        
        let crystalMine = (name: "Crystal Mine",
                           metal: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[0],
                           crystal: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[1],
                           deuterium: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[2],
                           image: (available: Images.Resources.SmallAvailable.crystalMine,
                                   unavailable: Images.Resources.SmallUnavailable.crystalMine,
                                   disabled: Images.Resources.SmallDisabled.crystalMine),
                           buildingsID: 2)
        
        let deuteriumMine = (name: "Deuterium Mine",
                             metal: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[0],
                             crystal: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[1],
                             deuterium: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[2],
                             image: (available: Images.Resources.SmallAvailable.deuteriumMine,
                                     unavailable: Images.Resources.SmallUnavailable.deuteriumMine,
                                     disabled: Images.Resources.SmallDisabled.deuteriumMine),
                             buildingsID: 3)
        
        let solarPlant = (name: "Solar Plant",
                          metal: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[0],
                          crystal: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[1],
                          deuterium: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[2],
                          image: (available: Images.Resources.SmallAvailable.solarPlant,
                                  unavailable: Images.Resources.SmallUnavailable.solarPlant,
                                  disabled: Images.Resources.SmallDisabled.solarPlant),
                          buildingsID: 4)
        
        let fusionPlant = (name: "Fusion Plant",
                           metal: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[0],
                           crystal: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[1],
                           deuterium: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[2],
                           image: (available: Images.Resources.SmallAvailable.fusionPlant,
                                   unavailable: Images.Resources.SmallUnavailable.fusionPlant,
                                   disabled: Images.Resources.SmallDisabled.fusionPlant),
                           buildingsID: 12)
        
        let metalStorage = (name: "Metal Storage",
                            metal: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[0],
                            crystal: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[1],
                            deuterium: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[2],
                            image: (available: Images.Resources.SmallAvailable.metalStorage,
                                    unavailable: Images.Resources.SmallUnavailable.metalStorage,
                                    disabled: Images.Resources.SmallDisabled.metalStorage),
                            buildingsID: 22)
        
        let crystalStorage = (name: "Crystal Storage",
                              metal: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[0],
                              crystal: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[1],
                              deuterium: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[2],
                              image: (available: Images.Resources.SmallAvailable.crystalStorage,
                                      unavailable: Images.Resources.SmallUnavailable.crystalStorage,
                                      disabled: Images.Resources.SmallDisabled.crystalStorage),
                              buildingsID: 23)
        
        let deuteriumStorage = (name: "Deuterium Storage",
                                metal: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[0],
                                crystal: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[1],
                                deuterium: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[2],
                                image: (available: Images.Resources.SmallAvailable.deuteriumStorage,
                                        unavailable: Images.Resources.SmallUnavailable.deuteriumStorage,
                                        disabled: Images.Resources.SmallDisabled.deuteriumStorage),
                                buildingsID: 24)
        
        let resourceBuildings = [metalMine, crystalMine, deuteriumMine, solarPlant, fusionPlant, metalStorage, crystalStorage, deuteriumStorage]
        
        typeOfBuilding = (resourceBuildings[id].buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = resourceBuildings[id].name
        metalRequiredLabel.text = "Metal: \(resourceBuildings[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(resourceBuildings[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(resourceBuildings[id].deuterium)"
        levelLabel.text = "\(supplies.allSupplies[id].level)"
        timeToBuildLabel.text = ""
        
        switch supplies.allSupplies[id].condition {
        case "on":
            buildingImage.image = resourceBuildings[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") //TODO: Change it
            levelLabel.text = "\(supplies.allSupplies[id].level) -> \(supplies.allSupplies[id].level + 1)"
        case "disabled":
            buildingImage.image = resourceBuildings[id].image.unavailable
        case "off":
            buildingImage.image = resourceBuildings[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET FACILITY
    func setFacility(id: Int, facilities: Facilities) {
        
        //TODO: Move all variables out of function
        //FIXME: Change all Large to SmallAvailable
        let roboticsFactory = (name: "Robotics Factory",
                               metal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[0],
                               crystal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[1],
                               deuterium: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[2],
                               image: (available: Images.Facilities.Large.roboticsFactory,
                                       unavailable: Images.Facilities.SmallUnavailable.roboticsFactory,
                                       disabled: Images.Facilities.SmallDisabled.roboticsFactory),
                               buildingsID: 14)
        
        let shipyard = (name: "Shipyard",
                        metal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[0],
                        crystal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[1],
                        deuterium: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[2],
                        image: (available: Images.Facilities.Large.shipyard,
                                unavailable: Images.Facilities.SmallUnavailable.shipyard,
                                disabled: Images.Facilities.SmallDisabled.shipyard),
                        buildingsID: 21)
        
        let researchLaboratory = (name: "Research Laboratory",
                                  metal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[0],
                                  crystal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[1],
                                  deuterium: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[2],
                                  image: (available: Images.Facilities.Large.researchLaboratory,
                                          unavailable: Images.Facilities.SmallUnavailable.researchLaboratory,
                                          disabled: Images.Facilities.SmallDisabled.researchLaboratory),
                                  buildingsID: 31)
        
        let allianceDepot = (name: "Alliance Depot",
                             metal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[0],
                             crystal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[1],
                             deuterium: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[2],
                             image: (available: Images.Facilities.Large.allianceDepot,
                                     unavailable: Images.Facilities.SmallUnavailable.allianceDepot,
                                     disabled: Images.Facilities.SmallDisabled.allianceDepot),
                             buildingsID: 34)
        
        let missileSilo = (name: "Missile Silo",
                           metal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[0],
                           crystal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[1],
                           deuterium: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[2],
                           image: (available: Images.Facilities.Large.missileSilo,
                                   unavailable: Images.Facilities.SmallUnavailable.missileSilo,
                                   disabled: Images.Facilities.SmallDisabled.missileSilo),
                           buildingsID: 44)
        
        let naniteFactory = (name: "Nanite Factory",
                             metal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[0],
                             crystal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[1],
                             deuterium: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[2],
                             image: (available: Images.Facilities.Large.naniteFactory,
                                     unavailable: Images.Facilities.SmallUnavailable.naniteFactory,
                                     disabled: Images.Facilities.SmallDisabled.naniteFactory),
                             buildingsID: 15)
        
        let terraformer = (name: "Terraformer",
                           metal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[0],
                           crystal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[1],
                           deuterium: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[2],
                           image: (available: Images.Facilities.Large.terraformer,
                                   unavailable: Images.Facilities.SmallUnavailable.terraformer,
                                   disabled: Images.Facilities.SmallDisabled.terraformer),
                           buildingsID: 33)
        
        let repairDock = (name: "Repair Dock",
                          metal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[0],
                          crystal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[1],
                          deuterium: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[2],
                          image: (available: Images.Facilities.Large.repairDock,
                                  unavailable: Images.Facilities.SmallUnavailable.repairDock,
                                  disabled: Images.Facilities.SmallDisabled.repairDock),
                          buildingsID: 36)
        
        // TODO: Implement moonBase
        // TODO: Implement sensorPhalanx
        // TODO: Implement jumpGate
        
        let facilityBuildings = [roboticsFactory, shipyard, researchLaboratory, allianceDepot, missileSilo, naniteFactory, terraformer, repairDock]
        
        typeOfBuilding = (facilityBuildings[id].buildingsID, 1, "supplies")
        buildButton.isEnabled = false
        buildingNameLabel.text = facilityBuildings[id].name
        metalRequiredLabel.text = "Metal: \(facilityBuildings[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(facilityBuildings[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(facilityBuildings[id].deuterium)"
        levelLabel.text = "\(facilities.allFacilities[id].level)"
        timeToBuildLabel.text = ""
        
        switch facilities.allFacilities[id].condition {
        case "on":
            buildingImage.image = facilityBuildings[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") //TODO: Change it
            levelLabel.text = "\(facilities.allFacilities[id].level) -> \(facilities.allFacilities[id].level + 1)"
        case "disabled":
            buildingImage.image = facilityBuildings[id].image.unavailable
        case "off":
            buildingImage.image = facilityBuildings[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
    
    
    // MARK: - SET RESEARCH
    func setResearch(id: Int, researches: Researches) {
        
        //TODO: Move all variables out of function
        let energy = (name: "Energy Technology",
                          metal: Price().get(technology: Researchings().energy, level: researches.energy.level)[0],
                          crystal: Price().get(technology: Researchings().energy, level: researches.energy.level)[1],
                          deuterium: Price().get(technology: Researchings().energy, level: researches.energy.level)[2],
                          image: (available: Images.Researches.SmallAvailable.energy,
                                  unavailable: Images.Researches.SmallUnavailable.energy,
                                  disabled: Images.Researches.SmallDisabled.energy),
                          buildingsID: 113)
        
        let laser = (name: "Laser Technology",
                          metal: Price().get(technology: Researchings().laser, level: researches.laser.level)[0],
                          crystal: Price().get(technology: Researchings().laser, level: researches.laser.level)[1],
                          deuterium: Price().get(technology: Researchings().laser, level: researches.laser.level)[2],
                          image: (available: Images.Researches.SmallAvailable.laser,
                                  unavailable: Images.Researches.SmallUnavailable.laser,
                                  disabled: Images.Researches.SmallDisabled.laser),
                          buildingsID: 120)
        
        let ion = (name: "Ion Technology",
                          metal: Price().get(technology: Researchings().ion, level: researches.ion.level)[0],
                          crystal: Price().get(technology: Researchings().ion, level: researches.ion.level)[1],
                          deuterium: Price().get(technology: Researchings().ion, level: researches.ion.level)[2],
                          image: (available: Images.Researches.SmallAvailable.ion,
                                  unavailable: Images.Researches.SmallUnavailable.ion,
                                  disabled: Images.Researches.SmallDisabled.ion),
                          buildingsID: 121)
        
        let hyperspace = (name: "Hyperspace Technology",
                          metal: Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[0],
                          crystal: Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[1],
                          deuterium: Price().get(technology: Researchings().hyperspace, level: researches.hyperspace.level)[2],
                          image: (available: Images.Researches.SmallAvailable.hyperspace,
                                  unavailable: Images.Researches.SmallUnavailable.hyperspace,
                                  disabled: Images.Researches.SmallDisabled.hyperspace),
                          buildingsID: 114)
        
        let plasma = (name: "Plasma Technology",
                          metal: Price().get(technology: Researchings().plasma, level: researches.plasma.level)[0],
                          crystal: Price().get(technology: Researchings().plasma, level: researches.plasma.level)[1],
                          deuterium: Price().get(technology: Researchings().plasma, level: researches.plasma.level)[2],
                          image: (available: Images.Researches.SmallAvailable.plasma,
                                  unavailable: Images.Researches.SmallUnavailable.plasma,
                                  disabled: Images.Researches.SmallDisabled.plasma),
                          buildingsID: 122)
        
        let combustionDrive = (name: "Combustion Drive",
                          metal: Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[0],
                          crystal: Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[1],
                          deuterium: Price().get(technology: Researchings().combustionDrive, level: researches.combustionDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.combustionDrive,
                                  unavailable: Images.Researches.SmallUnavailable.combustionDrive,
                                  disabled: Images.Researches.SmallDisabled.combustionDrive),
                          buildingsID: 115)
        
        let impulseDrive = (name: "Impulse Drive",
                          metal: Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[0],
                          crystal: Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[1],
                          deuterium: Price().get(technology: Researchings().impulseDrive, level: researches.impulseDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.impulseDrive,
                                  unavailable: Images.Researches.SmallUnavailable.impulseDrive,
                                  disabled: Images.Researches.SmallDisabled.impulseDrive),
                          buildingsID: 117)
        
        let hyperspaceDrive = (name: "Hyperspace Drive",
                          metal: Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[0],
                          crystal: Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[1],
                          deuterium: Price().get(technology: Researchings().hyperspaceDrive, level: researches.hyperspaceDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.hyperspaceDrive,
                                  unavailable: Images.Researches.SmallUnavailable.hyperspaceDrive,
                                  disabled: Images.Researches.SmallDisabled.hyperspaceDrive),
                          buildingsID: 118)
        
        let espionage = (name: "Espionage Technology",
                          metal: Price().get(technology: Researchings().espionage, level: researches.espionage.level)[0],
                          crystal: Price().get(technology: Researchings().espionage, level: researches.espionage.level)[1],
                          deuterium: Price().get(technology: Researchings().espionage, level: researches.espionage.level)[2],
                          image: (available: Images.Researches.SmallAvailable.espionage,
                                  unavailable: Images.Researches.SmallUnavailable.espionage,
                                  disabled: Images.Researches.SmallDisabled.espionage),
                          buildingsID: 106)
        
        let computer = (name: "Computer Technology",
                          metal: Price().get(technology: Researchings().computer, level: researches.computer.level)[0],
                          crystal: Price().get(technology: Researchings().computer, level: researches.computer.level)[1],
                          deuterium: Price().get(technology: Researchings().computer, level: researches.computer.level)[2],
                          image: (available: Images.Researches.SmallAvailable.computer,
                                  unavailable: Images.Researches.SmallUnavailable.computer,
                                  disabled: Images.Researches.SmallDisabled.computer),
                          buildingsID: 108)
        
        let astrophysics = (name: "Astrophysics",
                          metal: Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[0],
                          crystal: Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[1],
                          deuterium: Price().get(technology: Researchings().astrophysics, level: researches.astrophysics.level)[2],
                          image: (available: Images.Researches.SmallAvailable.astrophysics,
                                  unavailable: Images.Researches.SmallUnavailable.astrophysics,
                                  disabled: Images.Researches.SmallDisabled.astrophysics),
                          buildingsID: 124)
        
        let researchNetwork = (name: "Research Network",
                          metal: Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[0],
                          crystal: Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[1],
                          deuterium: Price().get(technology: Researchings().researchNetwork, level: researches.researchNetwork.level)[2],
                          image: (available: Images.Researches.SmallAvailable.researchNetwork,
                                  unavailable: Images.Researches.SmallUnavailable.researchNetwork,
                                  disabled: Images.Researches.SmallDisabled.researchNetwork),
                          buildingsID: 123)
        
        let graviton = (name: "Graviton Technology",
                          metal: Price().get(technology: Researchings().graviton, level: researches.graviton.level)[0],
                          crystal: Price().get(technology: Researchings().graviton, level: researches.graviton.level)[1],
                          deuterium: Price().get(technology: Researchings().graviton, level: researches.graviton.level)[2],
                          image: (available: Images.Researches.SmallAvailable.graviton,
                                  unavailable: Images.Researches.SmallUnavailable.graviton,
                                  disabled: Images.Researches.SmallDisabled.graviton),
                          buildingsID: 199)
        
        let weapons = (name: "Weapons Technology",
                          metal: Price().get(technology: Researchings().weapons, level: researches.weapons.level)[0],
                          crystal: Price().get(technology: Researchings().weapons, level: researches.weapons.level)[1],
                          deuterium: Price().get(technology: Researchings().weapons, level: researches.weapons.level)[2],
                          image: (available: Images.Researches.SmallAvailable.weapons,
                                  unavailable: Images.Researches.SmallUnavailable.weapons,
                                  disabled: Images.Researches.SmallDisabled.weapons),
                          buildingsID: 109)
        
        let shielding = (name: "Shielding Technology",
                          metal: Price().get(technology: Researchings().shielding, level: researches.shielding.level)[0],
                          crystal: Price().get(technology: Researchings().shielding, level: researches.shielding.level)[1],
                          deuterium: Price().get(technology: Researchings().shielding, level: researches.shielding.level)[2],
                          image: (available: Images.Researches.SmallAvailable.shielding,
                                  unavailable: Images.Researches.SmallUnavailable.shielding,
                                  disabled: Images.Researches.SmallDisabled.shielding),
                          buildingsID: 110)
        
        let armor = (name: "Armor Technology",
                          metal: Price().get(technology: Researchings().armor, level: researches.armor.level)[0],
                          crystal: Price().get(technology: Researchings().armor, level: researches.armor.level)[1],
                          deuterium: Price().get(technology: Researchings().armor, level: researches.armor.level)[2],
                          image: (available: Images.Researches.SmallAvailable.armor,
                                  unavailable: Images.Researches.SmallUnavailable.armor,
                                  disabled: Images.Researches.SmallDisabled.armor),
                          buildingsID: 111)
        
        let researchTechnologies = [energy, laser, ion, hyperspace, plasma, combustionDrive, impulseDrive, hyperspaceDrive, espionage, computer, astrophysics, researchNetwork, graviton, weapons, shielding, armor]
        
        typeOfBuilding = (researchTechnologies[id].buildingsID, 1, "research")
        buildButton.isEnabled = false
        buildingNameLabel.text = researchTechnologies[id].name
        metalRequiredLabel.text = "Metal: \(researchTechnologies[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(researchTechnologies[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(researchTechnologies[id].deuterium)"
        levelLabel.text = "\(researches.allResearches[id].level)"
        timeToBuildLabel.text = ""

        switch researches.allResearches[id].condition {
        case "on":
            buildingImage.image = researchTechnologies[id].image.available
            buildButton.isEnabled = true
        case "active":
            buildingImage.image = UIImage(systemName: "timer") //TODO: Change it
            levelLabel.text = "\(researches.allResearches[id].level) -> \(researches.allResearches[id].level + 1)"
        case "disabled":
            buildingImage.image = researchTechnologies[id].image.unavailable
        case "off":
            buildingImage.image = researchTechnologies[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
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
