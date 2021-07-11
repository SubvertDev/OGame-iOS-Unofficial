//
//  Facility+Facilities.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Facility {
    // FIXME: somehow change Bool? to Bool
    let level: Int
    var isPossible: Bool?
    var inConstruction: Bool?
    
    init(_ levels: [Int], _ status: [String], _ type: Int) {
        self.level = levels[type]
        self.isPossible = isPossible(status[type])
        self.inConstruction = inConstruction(status[type])
    }
    
    private func isPossible(_ string: String) -> Bool {
        string == "on" ? true : false
    }
    
    private func inConstruction(_ string: String) -> Bool {
        string == "active" ? true : false
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
