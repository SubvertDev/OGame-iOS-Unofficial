//
//  Facility+Facilities.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Facility {
    // TODO: Can I merge facility and facilites?
    let level: Int
    let condition: String
    
    init(_ levels: [Int], _ status: [String], _ type: Int) {
        self.level = levels[type]
        self.condition = status[type]
    }
}

struct Facilities {
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
        self.roboticsFactory = Facility(levels, status, 14)
        self.shipyard = Facility(levels, status, 21)
        self.researchLaboratory = Facility(levels, status, 31)
        self.allianceDepot = Facility(levels, status, 34)
        self.missileSilo = Facility(levels, status, 44)
        self.naniteFactory = Facility(levels, status, 15)
        self.terraformer = Facility(levels, status, 33)
        self.repairDock = Facility(levels, status, 36)

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
