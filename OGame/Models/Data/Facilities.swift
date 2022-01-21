//
//  Facility+Facilities.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Facilities {
    
    struct Facility {
        let level: Int
        let condition: String
        
        init(_ level: Int, _ status: String, _ type: Int) {
            self.level = level
            self.condition = status
        }
    }
    
    let roboticsFactory: Facility
    let shipyard: Facility
    let researchLaboratory: Facility
    let allianceDepot: Facility
    let missileSilo: Facility
    let naniteFactory: Facility
    let terraformer: Facility
    let repairDock: Facility

    let allFacilities: [Facility]

    init(_ levels: [Int], _ status: [String]) {
        self.roboticsFactory = Facility(levels[0], status[0], 14)
        self.shipyard = Facility(levels[1], status[1], 21)
        self.researchLaboratory = Facility(levels[2], status[2], 31)
        self.allianceDepot = Facility(levels[3], status[3], 34)
        self.missileSilo = Facility(levels[4], status[4], 44)
        self.naniteFactory = Facility(levels[5], status[5], 15)
        self.terraformer = Facility(levels[6], status[6], 33)
        self.repairDock = Facility(levels[7], status[7], 36)

        self.allFacilities = [
            self.roboticsFactory,
            self.shipyard,
            self.researchLaboratory,
            self.allianceDepot,
            self.missileSilo,
            self.naniteFactory,
            self.terraformer,
            self.repairDock
        ]
    }
}
