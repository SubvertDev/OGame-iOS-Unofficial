//
//  Supply.swift
//  OGame
//
//  Created by Subvert on 21.05.2021.
//

import Foundation

struct Supply {
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

struct Supplies {
    
    let metalMine: Supply
    let crystalMine: Supply
    let deuteriumMine: Supply
    let solarPlant: Supply
    let fusionPlant: Supply
    let metalStorage: Supply
    let crystalStorage: Supply
    let deuteriumStorage: Supply
    
    let allSupplies: [Supply]
        
    init(_ levels: [Int], _ status: [String]) {
        self.metalMine = Supply(levels, status, 0)
        self.crystalMine = Supply(levels, status, 1)
        self.deuteriumMine = Supply(levels, status, 2)
        self.solarPlant = Supply(levels, status, 3)
        self.fusionPlant = Supply(levels, status, 4)
        self.metalStorage = Supply(levels, status, 7)
        self.crystalStorage = Supply(levels, status, 8)
        self.deuteriumStorage = Supply(levels, status, 9)
        
        self.allSupplies = [
            self.metalMine,
            self.crystalMine,
            self.deuteriumMine,
            self.solarPlant,
            self.fusionPlant,
            self.metalStorage,
            self.crystalStorage,
            self.deuteriumStorage
        ]
    }
}



