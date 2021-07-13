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
        self.roboticsFactory = Facility(levels, status, 0)
        self.shipyard = Facility(levels, status, 1)
        self.researchLaboratory = Facility(levels, status, 2)
        self.allianceDepot = Facility(levels, status, 3)
        self.missileSilo = Facility(levels, status, 4)
        self.naniteFactory = Facility(levels, status, 5)
        self.terraformer = Facility(levels, status, 6)
        self.repairDock = Facility(levels, status, 7)
        
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
