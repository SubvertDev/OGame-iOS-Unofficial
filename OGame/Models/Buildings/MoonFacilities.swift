//
//  MoonFacilities.swift
//  OGame
//
//  Created by Subvert on 26.02.2022.
//

import Foundation

struct MoonFacilities {
    
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
    let moonBase: Facility
    let sensorPhalanx: Facility
    let jumpGate: Facility

    let allFacilities: [Facility]

    init(_ levels: [Int], _ status: [String]) {
        self.roboticsFactory = Facility(levels[0], status[0], 14)
        self.shipyard = Facility(levels[1], status[1], 21)
        self.moonBase = Facility(levels[2], status[2], 41)
        self.sensorPhalanx = Facility(levels[3], status[3], 42)
        self.jumpGate = Facility(levels[4], status[4], 43)

        self.allFacilities = [
            self.roboticsFactory,
            self.shipyard,
            self.moonBase,
            self.sensorPhalanx,
            self.jumpGate
        ]
    }
}
