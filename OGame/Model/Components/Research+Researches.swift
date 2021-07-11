//
//  Research+Researches.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Research {
    
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

struct Researches {
    
    let energy: Research
    let laser: Research
    let ion: Research
    let hyperspace: Research
    let plasma: Research
    let combustionDrive: Research
    let impulseDrive: Research
    let hyperspaceDrive: Research
    let espionage: Research
    let computer: Research
    let astrophysics: Research
    let researchNetwork: Research
    let graviton: Research
    let weapons: Research
    let shielding: Research
    let armor: Research
    
    let allResearches: [Research]
    
    init(_ levels: [Int], _ status: [String]) {
        self.energy = Research(levels, status, 0)
        self.laser = Research(levels, status, 1)
        self.ion = Research(levels, status, 2)
        self.hyperspace = Research(levels, status, 3)
        self.plasma = Research(levels, status, 4)
        self.combustionDrive = Research(levels, status, 5)
        self.impulseDrive = Research(levels, status, 6)
        self.hyperspaceDrive = Research(levels, status, 7)
        self.espionage = Research(levels, status, 8)
        self.computer = Research(levels, status, 9)
        self.astrophysics = Research(levels, status, 10)
        self.researchNetwork = Research(levels, status, 11)
        self.graviton = Research(levels, status, 12)
        self.weapons = Research(levels, status, 13)
        self.shielding = Research(levels, status, 14)
        self.armor = Research(levels, status, 15)
        
        self.allResearches = [
            self.energy,
            self.laser,
            self.ion,
            self.hyperspace,
            self.plasma,
            self.combustionDrive,
            self.impulseDrive,
            self.hyperspace,
            self.espionage,
            self.computer,
            self.astrophysics,
            self.researchNetwork,
            self.graviton,
            self.weapons,
            self.shielding,
            self.armor
        ]
    }
}
