//
//  Research+Researches.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Researches {
    
    struct Research {
        let level: Int
        let condition: String

        init(_ level: Int, _ status: String, _ type: Int) {
            self.level = level
            self.condition = status
        }
    }
    
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
        self.energy = Research(levels[0], status[0], 113)
        self.laser = Research(levels[1], status[1], 120)
        self.ion = Research(levels[2], status[2], 121)
        self.hyperspace = Research(levels[3], status[3], 114)
        self.plasma = Research(levels[4], status[4], 122)
        self.combustionDrive = Research(levels[5], status[5], 115)
        self.impulseDrive = Research(levels[6], status[6], 117)
        self.hyperspaceDrive = Research(levels[7], status[7], 118)
        self.espionage = Research(levels[8], status[8], 106)
        self.computer = Research(levels[9], status[9], 108)
        self.astrophysics = Research(levels[10], status[10], 124)
        self.researchNetwork = Research(levels[11], status[11], 123)
        self.graviton = Research(levels[12], status[12], 199)
        self.weapons = Research(levels[13], status[13], 109)
        self.shielding = Research(levels[14], status[14], 110)
        self.armor = Research(levels[15], status[15], 111)

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
