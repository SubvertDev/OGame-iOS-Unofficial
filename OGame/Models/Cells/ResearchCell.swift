//
//  ResearchCell.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

struct ResearchCell {

    var researchTechnologies: [BuildingWithLevelData]

    init(with researches: Researches) {

        let energy = (name: "Energy Technology",
                          metal: Price.get(technology: Buildings.energy, level: researches.energy.level)[0],
                          crystal: Price.get(technology: Buildings.energy, level: researches.energy.level)[1],
                          deuterium: Price.get(technology: Buildings.energy, level: researches.energy.level)[2],
                          image: (available: Images.Researches.SmallAvailable.energy,
                                  unavailable: Images.Researches.SmallUnavailable.energy,
                                  disabled: Images.Researches.SmallDisabled.energy),
                          buildingsID: 113,
                          level: researches.energy.level,
                          condition: researches.energy.condition)

        let laser = (name: "Laser Technology",
                          metal: Price.get(technology: Buildings.laser, level: researches.laser.level)[0],
                          crystal: Price.get(technology: Buildings.laser, level: researches.laser.level)[1],
                          deuterium: Price.get(technology: Buildings.laser, level: researches.laser.level)[2],
                          image: (available: Images.Researches.SmallAvailable.laser,
                                  unavailable: Images.Researches.SmallUnavailable.laser,
                                  disabled: Images.Researches.SmallDisabled.laser),
                          buildingsID: 120,
                          level: researches.laser.level,
                          condition: researches.laser.condition)

        let ion = (name: "Ion Technology",
                          metal: Price.get(technology: Buildings.ion, level: researches.ion.level)[0],
                          crystal: Price.get(technology: Buildings.ion, level: researches.ion.level)[1],
                          deuterium: Price.get(technology: Buildings.ion, level: researches.ion.level)[2],
                          image: (available: Images.Researches.SmallAvailable.ion,
                                  unavailable: Images.Researches.SmallUnavailable.ion,
                                  disabled: Images.Researches.SmallDisabled.ion),
                          buildingsID: 121,
                          level: researches.ion.level,
                          condition: researches.ion.condition)

        let hyperspace = (name: "Hyperspace Technology",
                          metal: Price.get(technology: Buildings.hyperspace, level: researches.hyperspace.level)[0],
                          crystal: Price.get(technology: Buildings.hyperspace, level: researches.hyperspace.level)[1],
                          deuterium: Price.get(technology: Buildings.hyperspace, level: researches.hyperspace.level)[2],
                          image: (available: Images.Researches.SmallAvailable.hyperspace,
                                  unavailable: Images.Researches.SmallUnavailable.hyperspace,
                                  disabled: Images.Researches.SmallDisabled.hyperspace),
                          buildingsID: 114,
                          level: researches.hyperspace.level,
                          condition: researches.hyperspace.condition)
        
        let plasma = (name: "Plasma Technology",
                          metal: Price.get(technology: Buildings.plasma, level: researches.plasma.level)[0],
                          crystal: Price.get(technology: Buildings.plasma, level: researches.plasma.level)[1],
                          deuterium: Price.get(technology: Buildings.plasma, level: researches.plasma.level)[2],
                          image: (available: Images.Researches.SmallAvailable.plasma,
                                  unavailable: Images.Researches.SmallUnavailable.plasma,
                                  disabled: Images.Researches.SmallDisabled.plasma),
                          buildingsID: 122,
                          level: researches.plasma.level,
                          condition: researches.plasma.condition)

        let combustionDrive = (name: "Combustion Drive",
                          metal: Price.get(technology: Buildings.combustionDrive, level: researches.combustionDrive.level)[0],
                          crystal: Price.get(technology: Buildings.combustionDrive, level: researches.combustionDrive.level)[1],
                          deuterium: Price.get(technology: Buildings.combustionDrive, level: researches.combustionDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.combustionDrive,
                                  unavailable: Images.Researches.SmallUnavailable.combustionDrive,
                                  disabled: Images.Researches.SmallDisabled.combustionDrive),
                          buildingsID: 115,
                          level: researches.combustionDrive.level,
                          condition: researches.combustionDrive.condition)

        let impulseDrive = (name: "Impulse Drive",
                          metal: Price.get(technology: Buildings.impulseDrive, level: researches.impulseDrive.level)[0],
                          crystal: Price.get(technology: Buildings.impulseDrive, level: researches.impulseDrive.level)[1],
                          deuterium: Price.get(technology: Buildings.impulseDrive, level: researches.impulseDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.impulseDrive,
                                  unavailable: Images.Researches.SmallUnavailable.impulseDrive,
                                  disabled: Images.Researches.SmallDisabled.impulseDrive),
                          buildingsID: 117,
                          level: researches.impulseDrive.level,
                          condition: researches.impulseDrive.condition)

        let hyperspaceDrive = (name: "Hyperspace Drive",
                          metal: Price.get(technology: Buildings.hyperspaceDrive, level: researches.hyperspaceDrive.level)[0],
                          crystal: Price.get(technology: Buildings.hyperspaceDrive, level: researches.hyperspaceDrive.level)[1],
                          deuterium: Price.get(technology: Buildings.hyperspaceDrive, level: researches.hyperspaceDrive.level)[2],
                          image: (available: Images.Researches.SmallAvailable.hyperspaceDrive,
                                  unavailable: Images.Researches.SmallUnavailable.hyperspaceDrive,
                                  disabled: Images.Researches.SmallDisabled.hyperspaceDrive),
                          buildingsID: 118,
                          level: researches.hyperspaceDrive.level,
                          condition: researches.hyperspaceDrive.condition)

        let espionage = (name: "Espionage Technology",
                          metal: Price.get(technology: Buildings.espionage, level: researches.espionage.level)[0],
                          crystal: Price.get(technology: Buildings.espionage, level: researches.espionage.level)[1],
                          deuterium: Price.get(technology: Buildings.espionage, level: researches.espionage.level)[2],
                          image: (available: Images.Researches.SmallAvailable.espionage,
                                  unavailable: Images.Researches.SmallUnavailable.espionage,
                                  disabled: Images.Researches.SmallDisabled.espionage),
                          buildingsID: 106,
                          level: researches.espionage.level,
                          condition: researches.espionage.condition)

        let computer = (name: "Computer Technology",
                          metal: Price.get(technology: Buildings.computer, level: researches.computer.level)[0],
                          crystal: Price.get(technology: Buildings.computer, level: researches.computer.level)[1],
                          deuterium: Price.get(technology: Buildings.computer, level: researches.computer.level)[2],
                          image: (available: Images.Researches.SmallAvailable.computer,
                                  unavailable: Images.Researches.SmallUnavailable.computer,
                                  disabled: Images.Researches.SmallDisabled.computer),
                          buildingsID: 108,
                          level: researches.computer.level,
                          condition: researches.computer.condition)

        let astrophysics = (name: "Astrophysics",
                          metal: Price.get(technology: Buildings.astrophysics, level: researches.astrophysics.level)[0],
                          crystal: Price.get(technology: Buildings.astrophysics, level: researches.astrophysics.level)[1],
                          deuterium: Price.get(technology: Buildings.astrophysics, level: researches.astrophysics.level)[2],
                          image: (available: Images.Researches.SmallAvailable.astrophysics,
                                  unavailable: Images.Researches.SmallUnavailable.astrophysics,
                                  disabled: Images.Researches.SmallDisabled.astrophysics),
                          buildingsID: 124,
                          level: researches.astrophysics.level,
                          condition: researches.astrophysics.condition)

        let researchNetwork = (name: "Research Network",
                          metal: Price.get(technology: Buildings.researchNetwork, level: researches.researchNetwork.level)[0],
                          crystal: Price.get(technology: Buildings.researchNetwork, level: researches.researchNetwork.level)[1],
                          deuterium: Price.get(technology: Buildings.researchNetwork, level: researches.researchNetwork.level)[2],
                          image: (available: Images.Researches.SmallAvailable.researchNetwork,
                                  unavailable: Images.Researches.SmallUnavailable.researchNetwork,
                                  disabled: Images.Researches.SmallDisabled.researchNetwork),
                          buildingsID: 123,
                          level: researches.researchNetwork.level,
                          condition: researches.researchNetwork.condition)

        let graviton = (name: "Graviton Technology",
                          metal: Price.get(technology: Buildings.graviton, level: researches.graviton.level)[0],
                          crystal: Price.get(technology: Buildings.graviton, level: researches.graviton.level)[1],
                          deuterium: Price.get(technology: Buildings.graviton, level: researches.graviton.level)[2],
                          image: (available: Images.Researches.SmallAvailable.graviton,
                                  unavailable: Images.Researches.SmallUnavailable.graviton,
                                  disabled: Images.Researches.SmallDisabled.graviton),
                          buildingsID: 199,
                          level: researches.graviton.level,
                          condition: researches.graviton.condition)

        let weapons = (name: "Weapons Technology",
                          metal: Price.get(technology: Buildings.weapons, level: researches.weapons.level)[0],
                          crystal: Price.get(technology: Buildings.weapons, level: researches.weapons.level)[1],
                          deuterium: Price.get(technology: Buildings.weapons, level: researches.weapons.level)[2],
                          image: (available: Images.Researches.SmallAvailable.weapons,
                                  unavailable: Images.Researches.SmallUnavailable.weapons,
                                  disabled: Images.Researches.SmallDisabled.weapons),
                          buildingsID: 109,
                          level: researches.weapons.level,
                          condition: researches.weapons.condition)

        let shielding = (name: "Shielding Technology",
                          metal: Price.get(technology: Buildings.shielding, level: researches.shielding.level)[0],
                          crystal: Price.get(technology: Buildings.shielding, level: researches.shielding.level)[1],
                          deuterium: Price.get(technology: Buildings.shielding, level: researches.shielding.level)[2],
                          image: (available: Images.Researches.SmallAvailable.shielding,
                                  unavailable: Images.Researches.SmallUnavailable.shielding,
                                  disabled: Images.Researches.SmallDisabled.shielding),
                          buildingsID: 110,
                          level: researches.shielding.level,
                          condition: researches.shielding.condition)

        let armor = (name: "Armor Technology",
                          metal: Price.get(technology: Buildings.armor, level: researches.armor.level)[0],
                          crystal: Price.get(technology: Buildings.armor, level: researches.armor.level)[1],
                          deuterium: Price.get(technology: Buildings.armor, level: researches.armor.level)[2],
                          image: (available: Images.Researches.SmallAvailable.armor,
                                  unavailable: Images.Researches.SmallUnavailable.armor,
                                  disabled: Images.Researches.SmallDisabled.armor),
                          buildingsID: 111,
                          level: researches.armor.level,
                          condition: researches.armor.condition)

        researchTechnologies = [energy,
                                laser,
                                ion,
                                hyperspace,
                                plasma,
                                combustionDrive,
                                impulseDrive,
                                hyperspaceDrive,
                                espionage,
                                computer,
                                astrophysics,
                                researchNetwork,
                                graviton,
                                weapons,
                                shielding,
                                armor]
    }
}
