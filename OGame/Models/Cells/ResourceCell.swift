//
//  ResourceCell.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

struct ResourceCell {
    
    var resourceBuildings: BuildingsData

    init(with supplies: Supplies) {

        let metalMine = (name: "Metal Mine",
                         metal: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[0],
                         crystal: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[1],
                         deuterium: Price().get(technology: Buildings().metalMine, level: supplies.metalMine.level)[2],
                         image: (available: Images.Resources.SmallAvailable.metalMine,
                                 unavailable: Images.Resources.SmallUnavailable.metalMine,
                                 disabled: Images.Resources.SmallDisabled.metalMine),
                         buildingsID: 1,
                         level: supplies.metalMine.level,
                         condition: supplies.metalMine.condition)

        let crystalMine = (name: "Crystal Mine",
                           metal: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[0],
                           crystal: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[1],
                           deuterium: Price().get(technology: Buildings().crystalMine, level: supplies.crystalMine.level)[2],
                           image: (available: Images.Resources.SmallAvailable.crystalMine,
                                   unavailable: Images.Resources.SmallUnavailable.crystalMine,
                                   disabled: Images.Resources.SmallDisabled.crystalMine),
                           buildingsID: 2,
                           level: supplies.crystalMine.level,
                           condition: supplies.crystalMine.condition)

        let deuteriumMine = (name: "Deuterium Mine",
                             metal: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[0],
                             crystal: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[1],
                             deuterium: Price().get(technology: Buildings().deuteriumMine, level: supplies.deuteriumMine.level)[2],
                             image: (available: Images.Resources.SmallAvailable.deuteriumMine,
                                     unavailable: Images.Resources.SmallUnavailable.deuteriumMine,
                                     disabled: Images.Resources.SmallDisabled.deuteriumMine),
                             buildingsID: 3,
                             level: supplies.deuteriumMine.level,
                             condition: supplies.deuteriumMine.condition)

        let solarPlant = (name: "Solar Plant",
                          metal: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[0],
                          crystal: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[1],
                          deuterium: Price().get(technology: Buildings().solarPlant, level: supplies.solarPlant.level)[2],
                          image: (available: Images.Resources.SmallAvailable.solarPlant,
                                  unavailable: Images.Resources.SmallUnavailable.solarPlant,
                                  disabled: Images.Resources.SmallDisabled.solarPlant),
                          buildingsID: 4,
                          level: supplies.solarPlant.level,
                          condition: supplies.solarPlant.condition)

        let fusionPlant = (name: "Fusion Plant",
                           metal: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[0],
                           crystal: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[1],
                           deuterium: Price().get(technology: Buildings().fusionPlant, level: supplies.fusionPlant.level)[2],
                           image: (available: Images.Resources.SmallAvailable.fusionPlant,
                                   unavailable: Images.Resources.SmallUnavailable.fusionPlant,
                                   disabled: Images.Resources.SmallDisabled.fusionPlant),
                           buildingsID: 12,
                           level: supplies.fusionPlant.level,
                           condition: supplies.fusionPlant.condition)

        let metalStorage = (name: "Metal Storage",
                            metal: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[0],
                            crystal: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[1],
                            deuterium: Price().get(technology: Buildings().metalStorage, level: supplies.metalStorage.level)[2],
                            image: (available: Images.Resources.SmallAvailable.metalStorage,
                                    unavailable: Images.Resources.SmallUnavailable.metalStorage,
                                    disabled: Images.Resources.SmallDisabled.metalStorage),
                            buildingsID: 22,
                            level: supplies.metalStorage.level,
                            condition: supplies.metalStorage.condition)

        let crystalStorage = (name: "Crystal Storage",
                              metal: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[0],
                              crystal: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[1],
                              deuterium: Price().get(technology: Buildings().crystalStorage, level: supplies.crystalStorage.level)[2],
                              image: (available: Images.Resources.SmallAvailable.crystalStorage,
                                      unavailable: Images.Resources.SmallUnavailable.crystalStorage,
                                      disabled: Images.Resources.SmallDisabled.crystalStorage),
                              buildingsID: 23,
                              level: supplies.crystalStorage.level,
                              condition: supplies.crystalStorage.condition)

        let deuteriumStorage = (name: "Deuterium Storage",
                                metal: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[0],
                                crystal: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[1],
                                deuterium: Price().get(technology: Buildings().deuteriumStorage, level: supplies.deuteriumStorage.level)[2],
                                image: (available: Images.Resources.SmallAvailable.deuteriumStorage,
                                        unavailable: Images.Resources.SmallUnavailable.deuteriumStorage,
                                        disabled: Images.Resources.SmallDisabled.deuteriumStorage),
                                buildingsID: 24,
                                level: supplies.deuteriumStorage.level,
                                condition: supplies.deuteriumStorage.condition)

        resourceBuildings = [metalMine,
                             crystalMine,
                             deuteriumMine,
                             solarPlant,
                             fusionPlant,
                             metalStorage,
                             crystalStorage,
                             deuteriumStorage]
    }
}
