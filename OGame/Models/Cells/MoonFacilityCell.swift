//
//  MoonFacilityCell.swift
//  OGame
//
//  Created by Subvert on 26.02.2022.
//

import UIKit

struct MoonFacilityCell {

    var moonFacilityBuildings: [BuildingWithLevelData]

    init(with facilities: MoonFacilities) {

        let roboticsFactory = (name: "Robotics Factory",
                               metal: Price.get(technology: Buildings.roboticsFactory, level: facilities.roboticsFactory.level)[0],
                               crystal: Price.get(technology: Buildings.roboticsFactory, level: facilities.roboticsFactory.level)[1],
                               deuterium: Price.get(technology: Buildings.roboticsFactory, level: facilities.roboticsFactory.level)[2],
                               image: (available: Images.Facilities.SmallAvailable.roboticsFactory,
                                       unavailable: Images.Facilities.SmallUnavailable.roboticsFactory,
                                       disabled: Images.Facilities.SmallDisabled.roboticsFactory),
                               buildingsID: 14,
                               level: facilities.roboticsFactory.level,
                               condition: facilities.roboticsFactory.condition)

        let shipyard = (name: "Shipyard",
                        metal: Price.get(technology: Buildings.shipyard, level: facilities.shipyard.level)[0],
                        crystal: Price.get(technology: Buildings.shipyard, level: facilities.shipyard.level)[1],
                        deuterium: Price.get(technology: Buildings.shipyard, level: facilities.shipyard.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.shipyard,
                                unavailable: Images.Facilities.SmallUnavailable.shipyard,
                                disabled: Images.Facilities.SmallDisabled.shipyard),
                        buildingsID: 21,
                        level: facilities.shipyard.level,
                        condition: facilities.shipyard.condition)
        
        
        let moonBase = (name: "Lunar Base",
                        metal: Price.get(technology: Buildings.moonBase, level: facilities.moonBase.level)[0],
                        crystal: Price.get(technology: Buildings.moonBase, level: facilities.moonBase.level)[1],
                        deuterium: Price.get(technology: Buildings.moonBase, level: facilities.moonBase.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.moonBase,
                                unavailable: Images.Facilities.SmallUnavailable.moonBase,
                                disabled: Images.Facilities.SmallDisabled.moonBase),
                        buildingsID: 41, 
                        level: facilities.moonBase.level,
                        condition: facilities.moonBase.condition)
        
        
        let sensorPhalanx = (name: "Sensor Phalanx",
                        metal: Price.get(technology: Buildings.sensorPhalanx, level: facilities.sensorPhalanx.level)[0],
                        crystal: Price.get(technology: Buildings.sensorPhalanx, level: facilities.sensorPhalanx.level)[1],
                        deuterium: Price.get(technology: Buildings.sensorPhalanx, level: facilities.sensorPhalanx.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.sensorPhalanx,
                                unavailable: Images.Facilities.SmallUnavailable.sensorPhalanx,
                                disabled: Images.Facilities.SmallDisabled.sensorPhalanx),
                        buildingsID: 42,
                        level: facilities.sensorPhalanx.level,
                        condition: facilities.sensorPhalanx.condition)
        
        
        let jumpGate = (name: "Jump Gate",
                        metal: Price.get(technology: Buildings.jumpGate, level: facilities.jumpGate.level)[0],
                        crystal: Price.get(technology: Buildings.jumpGate, level: facilities.jumpGate.level)[1],
                        deuterium: Price.get(technology: Buildings.jumpGate, level: facilities.jumpGate.level)[2],
                        image: (available: Images.Facilities.SmallAvailable.jumpGate,
                                unavailable: Images.Facilities.SmallUnavailable.jumpGate,
                                disabled: Images.Facilities.SmallDisabled.jumpGate),
                        buildingsID: 43,
                        level: facilities.jumpGate.level,
                        condition: facilities.jumpGate.condition)

        moonFacilityBuildings = [roboticsFactory,
                                 shipyard,
                                 moonBase,
                                 sensorPhalanx,
                                 jumpGate]
    }
}
