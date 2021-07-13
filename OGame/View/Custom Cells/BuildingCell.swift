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
    func setSupply(id: Int, supplies: Supplies) {
        
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
        // TODO: Hide 0 resource labels
        
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
        let roboticsFactory = (name: "Robotics Factory",
                               metal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[0],
                               crystal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[1],
                               deuterium: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[2],
                               image: (available: Images.Facilities.SmallAvailable.roboticsFactory,
                                       unavailable: Images.Facilities.SmallUnavailable.roboticsFactory,
                                       disabled: Images.Facilities.SmallDisabled.roboticsFactory),
                               buildingsID: 14)
        
        let shipyard = (name: "Shipyard",
                        metal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[0],
                        crystal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[1],
                        deuterium: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.shipyard,
                                unavailable: Images.Facilities.SmallUnavailable.shipyard,
                                disabled: Images.Facilities.SmallDisabled.shipyard),
                        buildingsID: 21)
        
        let researchLaboratory = (name: "Research Laboratory",
                                  metal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[0],
                                  crystal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[1],
                                  deuterium: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[2],
                                  image: (available: Images.Facilities.SmallAvailable.researchLaboratory,
                                          unavailable: Images.Facilities.SmallUnavailable.researchLaboratory,
                                          disabled: Images.Facilities.SmallDisabled.researchLaboratory),
                                  buildingsID: 31)
        
        let allianceDepot = (name: "Alliance Depot",
                             metal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[0],
                             crystal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[1],
                             deuterium: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[2],
                             image: (available: Images.Facilities.SmallAvailable.allianceDepot,
                                     unavailable: Images.Facilities.SmallUnavailable.allianceDepot,
                                     disabled: Images.Facilities.SmallDisabled.allianceDepot),
                             buildingsID: 34)
        
        let missileSilo = (name: "Missile Silo",
                           metal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[0],
                           crystal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[1],
                           deuterium: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[2],
                           image: (available: Images.Facilities.SmallAvailable.missileSilo,
                                   unavailable: Images.Facilities.SmallUnavailable.missileSilo,
                                   disabled: Images.Facilities.SmallDisabled.missileSilo),
                           buildingsID: 44)
        
        let naniteFactory = (name: "Nanite Factory",
                             metal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[0],
                             crystal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[1],
                             deuterium: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[2],
                             image: (available: Images.Facilities.SmallAvailable.naniteFactory,
                                     unavailable: Images.Facilities.SmallUnavailable.naniteFactory,
                                     disabled: Images.Facilities.SmallDisabled.naniteFactory),
                             buildingsID: 15)
        
        let terraformer = (name: "Terraformer",
                           metal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[0],
                           crystal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[1],
                           deuterium: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[2],
                           image: (available: Images.Facilities.SmallAvailable.terraformer,
                                   unavailable: Images.Facilities.SmallUnavailable.terraformer,
                                   disabled: Images.Facilities.SmallDisabled.terraformer),
                           buildingsID: 33)
        
        let repairDock = (name: "Repair Dock",
                          metal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[0],
                          crystal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[1],
                          deuterium: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[2],
                          image: (available: Images.Facilities.SmallAvailable.repairDock,
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
        // TODO: Hide 0 resources labels
        
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
    func setShip(id: Int, ships: Ships) {
        
        amountTextField.isHidden = false
        
        let lightFighter = (name: "Light Fighter",
                          metal: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[0],
                          crystal: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[1],
                          deuterium: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.lightFighter,
                                  unavailable: Images.Ships.SmallUnavailable.lightFighter,
                                  disabled: Images.Ships.SmallDisabled.lightFighter),
                          buildingsID: 204)
        
        let heavyFighter = (name: "Heavy Fighter",
                          metal: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[0],
                          crystal: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[1],
                          deuterium: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.heavyFighter,
                                  unavailable: Images.Ships.SmallUnavailable.heavyFighter,
                                  disabled: Images.Ships.SmallDisabled.heavyFighter),
                          buildingsID: 205)
        
        let cruiser = (name: "Cruiser",
                          metal: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[0],
                          crystal: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[1],
                          deuterium: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.cruiser,
                                  unavailable: Images.Ships.SmallUnavailable.cruiser,
                                  disabled: Images.Ships.SmallDisabled.cruiser),
                          buildingsID: 206)
        
        let battleship = (name: "Battleship",
                          metal: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[0],
                          crystal: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[1],
                          deuterium: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.battleship,
                                  unavailable: Images.Ships.SmallUnavailable.battleship,
                                  disabled: Images.Ships.SmallDisabled.battleship),
                          buildingsID: 207)
        
        let battlecruiser = (name: "Battlecruiser",
                          metal: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[0],
                          crystal: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[1],
                          deuterium: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.battlecruiser,
                                  unavailable: Images.Ships.SmallUnavailable.battlecruiser,
                                  disabled: Images.Ships.SmallDisabled.battlecruiser),
                          buildingsID: 215)
        
        let bomber = (name: "Bomber",
                          metal: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[0],
                          crystal: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[1],
                          deuterium: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.bomber,
                                  unavailable: Images.Ships.SmallUnavailable.bomber,
                                  disabled: Images.Ships.SmallDisabled.bomber),
                          buildingsID: 211)
        
        let destroyer = (name: "Destroyer",
                          metal: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[0],
                          crystal: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[1],
                          deuterium: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.destroyer,
                                  unavailable: Images.Ships.SmallUnavailable.destroyer,
                                  disabled: Images.Ships.SmallDisabled.destroyer),
                          buildingsID: 213)
        
        let deathstar = (name: "Deathstar",
                          metal: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[0],
                          crystal: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[1],
                          deuterium: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.deathstar,
                                  unavailable: Images.Ships.SmallUnavailable.deathstar,
                                  disabled: Images.Ships.SmallDisabled.deathstar),
                          buildingsID: 214)
        
        let reaper = (name: "Reaper",
                          metal: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[0],
                          crystal: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[1],
                          deuterium: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.reaper,
                                  unavailable: Images.Ships.SmallUnavailable.reaper,
                                  disabled: Images.Ships.SmallDisabled.reaper),
                          buildingsID: 218)
        
        let pathfinder = (name: "Pathfinder",
                          metal: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[0],
                          crystal: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[1],
                          deuterium: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.pathfinder,
                                  unavailable: Images.Ships.SmallUnavailable.pathfinder,
                                  disabled: Images.Ships.SmallDisabled.pathfinder),
                          buildingsID: 219)
        
        let smallCargo = (name: "Small Cargo",
                          metal: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[0],
                          crystal: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[1],
                          deuterium: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.smallCargo,
                                  unavailable: Images.Ships.SmallUnavailable.smallCargo,
                                  disabled: Images.Ships.SmallDisabled.smallCargo),
                          buildingsID: 202)
        
        let largeCargo = (name: "Large Cargo",
                          metal: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[0],
                          crystal: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[1],
                          deuterium: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.largeCargo,
                                  unavailable: Images.Ships.SmallUnavailable.largeCargo,
                                  disabled: Images.Ships.SmallDisabled.largeCargo),
                          buildingsID: 203)
        
        let colonyShip = (name: "",
                          metal: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[0],
                          crystal: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[1],
                          deuterium: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.colonyShip,
                                  unavailable: Images.Ships.SmallUnavailable.colonyShip,
                                  disabled: Images.Ships.SmallDisabled.colonyShip),
                          buildingsID: 208)
        
        let recycler = (name: "Recycler",
                          metal: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[0],
                          crystal: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[1],
                          deuterium: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.recycler,
                                  unavailable: Images.Ships.SmallUnavailable.recycler,
                                  disabled: Images.Ships.SmallDisabled.recycler),
                          buildingsID: 209)
        
        let espionageProbe = (name: "Espionage Probe",
                          metal: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[0],
                          crystal: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[1],
                          deuterium: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.espionageProbe,
                                  unavailable: Images.Ships.SmallUnavailable.espionageProbe,
                                  disabled: Images.Ships.SmallDisabled.espionageProbe),
                          buildingsID: 210)
        
        let solarSatellite = (name: "Solar Satellite",
                          metal: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[0],
                          crystal: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[1],
                          deuterium: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.solarSatellite,
                                  unavailable: Images.Ships.SmallUnavailable.solarSatellite,
                                  disabled: Images.Ships.SmallDisabled.solarSatellite),
                          buildingsID: 212)
        
        let crawler = (name: "Crawler",
                          metal: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[0],
                          crystal: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[1],
                          deuterium: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.crawler,
                                  unavailable: Images.Ships.SmallUnavailable.crawler,
                                  disabled: Images.Ships.SmallDisabled.crawler),
                          buildingsID: 217)
        
        let shipsTechnologies = [lightFighter, heavyFighter, cruiser, battleship, battlecruiser, bomber, destroyer, deathstar, reaper, pathfinder, smallCargo, largeCargo, colonyShip, recycler, espionageProbe, solarSatellite, crawler]
        
        typeOfBuilding = (shipsTechnologies[id].buildingsID, 1, "shipyard")
        buildButton.isEnabled = false
        buildingNameLabel.text = shipsTechnologies[id].name
        metalRequiredLabel.text = "Metal: \(shipsTechnologies[id].metal)"
        crystalRequiredLabel.text = "Crystal: \(shipsTechnologies[id].crystal)"
        deuteriumRequiredLabel.text = "Deuterium: \(shipsTechnologies[id].deuterium)"
        levelLabel.text = "\(ships.allShips[id].amount)"
        timeToBuildLabel.text = ""
        
        // TODO: Add building queue for ships
        // This is check to restrict building more than one type at a time
        var shipActive = false
        for ship in ships.allShips {
            if ship.condition == "active" {
                shipActive = true
            }
        }
        
        switch ships.allShips[id].condition {
        case "on":
            if shipActive {
                buildingImage.image = shipsTechnologies[id].image.unavailable
            } else {
                buildingImage.image = shipsTechnologies[id].image.available
                buildButton.isEnabled = true
            }
        case "active":
            buildingImage.image = UIImage(systemName: "timer") //TODO: Change it
            //levelLabel.text = "\(ships.allShips[id].amount) -> \(ships.allShips[id].amount + 1)"
        case "disabled":
            buildingImage.image = shipsTechnologies[id].image.unavailable
        case "off":
            buildingImage.image = shipsTechnologies[id].image.disabled
        default:
            buildingImage.image = UIImage(systemName: "xmark")
        }
    }
}
