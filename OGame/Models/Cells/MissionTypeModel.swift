//
//  MissionTypeModel.swift
//  OGame
//
//  Created by Subvert on 23.01.2022.
//

import Foundation
import UIKit

struct MissionTypeModel {
    
    var missionTypes: [(name: String,
                        type: Mission,
                        images: (available: UIImage?,
                                 unavailable: UIImage?,
                                 availableSelected: UIImage?,
                                 unavailableSelected: UIImage?))]
    
    init() {
        let attack = (name: "Attack",
                      type: Mission.attack,
                      images: (available: Images.MissionTypes.Available.attack,
                               unavailable: Images.MissionTypes.Unavailable.attack,
                               availableSelected: Images.MissionTypes.AvailableSelected.attack,
                               unavailableSelected: Images.MissionTypes.UnavailableSelected.attack))
        let acsAttack = (name: "ACS Attack",
                         type: Mission.acsAttack,
                         images: (available: Images.MissionTypes.Available.acsAttack,
                                  unavailable: Images.MissionTypes.Unavailable.acsAttack,
                                  availableSelected: Images.MissionTypes.AvailableSelected.acsAttack,
                                  unavailableSelected: Images.MissionTypes.UnavailableSelected.acsAttack))
        let transport = (name: "Transport",
                         type: Mission.transport,
                         images: (available: Images.MissionTypes.Available.transport,
                                  unavailable: Images.MissionTypes.Unavailable.transport,
                                  availableSelected: Images.MissionTypes.AvailableSelected.transport,
                                  unavailableSelected: Images.MissionTypes.UnavailableSelected.transport))
        let deployment = (name: "Deployment",
                          type: Mission.deployment,
                          images: (available: Images.MissionTypes.Available.deployment,
                                   unavailable: Images.MissionTypes.Unavailable.deployment,
                                   availableSelected: Images.MissionTypes.AvailableSelected.deployment,
                                   unavailableSelected: Images.MissionTypes.UnavailableSelected.deployment))
        let acsDefend = (name: "ACS Defend",
                         type: Mission.acsDefend,
                         images: (available: Images.MissionTypes.Available.acsDefend,
                                  unavailable: Images.MissionTypes.Unavailable.acsDefend,
                                  availableSelected: Images.MissionTypes.AvailableSelected.acsDefend,
                                  unavailableSelected: Images.MissionTypes.UnavailableSelected.acsDefend))
        let espionage = (name: "Espionage",
                         type: Mission.espionage,
                         images: (available: Images.MissionTypes.Available.espionage,
                                  unavailable: Images.MissionTypes.Unavailable.espionage,
                                  availableSelected: Images.MissionTypes.AvailableSelected.espionage,
                                  unavailableSelected: Images.MissionTypes.UnavailableSelected.espionage))
        let colonisation = (name: "Colonisation",
                            type: Mission.colonisation,
                            images: (available: Images.MissionTypes.Available.colonisation,
                                     unavailable: Images.MissionTypes.Unavailable.colonisation,
                                     availableSelected: Images.MissionTypes.AvailableSelected.colonisation,
                                     unavailableSelected: Images.MissionTypes.UnavailableSelected.colonisation))
        let recycle = (name: "Recycle",
                       type: Mission.recycle,
                       images: (available: Images.MissionTypes.Available.recycle,
                                unavailable: Images.MissionTypes.Unavailable.recycle,
                                availableSelected: Images.MissionTypes.AvailableSelected.recycle,
                                unavailableSelected: Images.MissionTypes.UnavailableSelected.recycle))
        let moonDestruction = (name: "Moon Dest.",
                               type: Mission.moonDestruction,
                               images: (available: Images.MissionTypes.Available.moonDestruction,
                                        unavailable: Images.MissionTypes.Unavailable.moonDestruction,
                                        availableSelected: Images.MissionTypes.AvailableSelected.moonDestruction,
                                        unavailableSelected: Images.MissionTypes.UnavailableSelected.moonDestruction))
        let expedition = (name: "Expedition",
                          type: Mission.expedition,
                          images: (available: Images.MissionTypes.Available.expedition,
                                   unavailable: Images.MissionTypes.Unavailable.expedition,
                                   availableSelected: Images.MissionTypes.AvailableSelected.expedition,
                                   unavailableSelected: Images.MissionTypes.UnavailableSelected.expedition))
        
        missionTypes = [attack,
                        acsAttack,
                        transport,
                        deployment,
                        acsDefend,
                        espionage,
                        colonisation,
                        recycle,
                        moonDestruction,
                        expedition]
    }
}
