//
//  FacilityCell.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

struct FacilityCell {

    var facilityBuildings: BuildingsData

    init(with facilities: Facilities) {

        let roboticsFactory = (name: "Robotics Factory",
                               metal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[0],
                               crystal: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[1],
                               deuterium: Price().get(technology: Buildings().roboticsFactory, level: facilities.roboticsFactory.level)[2],
                               image: (available: Images.Facilities.SmallAvailable.roboticsFactory,
                                       unavailable: Images.Facilities.SmallUnavailable.roboticsFactory,
                                       disabled: Images.Facilities.SmallDisabled.roboticsFactory),
                               buildingsID: 14,
                               level: facilities.roboticsFactory.level,
                               condition: facilities.roboticsFactory.condition)

        let shipyard = (name: "Shipyard",
                        metal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[0],
                        crystal: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[1],
                        deuterium: Price().get(technology: Buildings().shipyard, level: facilities.shipyard.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.shipyard,
                                unavailable: Images.Facilities.SmallUnavailable.shipyard,
                                disabled: Images.Facilities.SmallDisabled.shipyard),
                        buildingsID: 21,
                        level: facilities.shipyard.level,
                        condition: facilities.shipyard.condition)

        let researchLaboratory = (name: "Research Laboratory",
                                  metal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[0],
                                  crystal: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[1],
                                  deuterium: Price().get(technology: Buildings().researchLaboratory, level: facilities.researchLaboratory.level)[2],
                                  image: (available: Images.Facilities.SmallAvailable.researchLaboratory,
                                          unavailable: Images.Facilities.SmallUnavailable.researchLaboratory,
                                          disabled: Images.Facilities.SmallDisabled.researchLaboratory),
                                  buildingsID: 31,
                                  level: facilities.researchLaboratory.level,
                                  condition: facilities.researchLaboratory.condition)

        let allianceDepot = (name: "Alliance Depot",
                             metal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[0],
                             crystal: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[1],
                             deuterium: Price().get(technology: Buildings().allianceDepot, level: facilities.allianceDepot.level)[2],
                             image: (available: Images.Facilities.SmallAvailable.allianceDepot,
                                     unavailable: Images.Facilities.SmallUnavailable.allianceDepot,
                                     disabled: Images.Facilities.SmallDisabled.allianceDepot),
                             buildingsID: 34,
                             level: facilities.allianceDepot.level,
                             condition: facilities.allianceDepot.condition)

        let missileSilo = (name: "Missile Silo",
                           metal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[0],
                           crystal: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[1],
                           deuterium: Price().get(technology: Buildings().missileSilo, level: facilities.missileSilo.level)[2],
                           image: (available: Images.Facilities.SmallAvailable.missileSilo,
                                   unavailable: Images.Facilities.SmallUnavailable.missileSilo,
                                   disabled: Images.Facilities.SmallDisabled.missileSilo),
                           buildingsID: 44,
                           level: facilities.missileSilo.level,
                           condition: facilities.missileSilo.condition)

        let naniteFactory = (name: "Nanite Factory",
                             metal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[0],
                             crystal: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[1],
                             deuterium: Price().get(technology: Buildings().naniteFactory, level: facilities.naniteFactory.level)[2],
                             image: (available: Images.Facilities.SmallAvailable.naniteFactory,
                                     unavailable: Images.Facilities.SmallUnavailable.naniteFactory,
                                     disabled: Images.Facilities.SmallDisabled.naniteFactory),
                             buildingsID: 15,
                             level: facilities.naniteFactory.level,
                             condition: facilities.naniteFactory.condition)

        let terraformer = (name: "Terraformer",
                           metal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[0],
                           crystal: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[1],
                           deuterium: Price().get(technology: Buildings().terraformer, level: facilities.terraformer.level)[2],
                           image: (available: Images.Facilities.SmallAvailable.terraformer,
                                   unavailable: Images.Facilities.SmallUnavailable.terraformer,
                                   disabled: Images.Facilities.SmallDisabled.terraformer),
                           buildingsID: 33,
                           level: facilities.terraformer.level,
                           condition: facilities.terraformer.condition)

        let repairDock = (name: "Repair Dock",
                          metal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[0],
                          crystal: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[1],
                          deuterium: Price().get(technology: Buildings().repairDock, level: facilities.repairDock.level)[2],
                          image: (available: Images.Facilities.SmallAvailable.repairDock,
                                  unavailable: Images.Facilities.SmallUnavailable.repairDock,
                                  disabled: Images.Facilities.SmallDisabled.repairDock),
                          buildingsID: 36,
                          level: facilities.repairDock.level,
                          condition: facilities.repairDock.condition)

        // TODO: Implement moonBase
        // TODO: Implement sensorPhalanx
        // TODO: Implement jumpGate

        facilityBuildings = [roboticsFactory,
                             shipyard,
                             researchLaboratory,
                             allianceDepot,
                             missileSilo,
                             naniteFactory,
                             terraformer,
                             repairDock]
    }
}
