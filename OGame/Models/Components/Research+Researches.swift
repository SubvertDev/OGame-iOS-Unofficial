//
//  Research+Researches.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import Foundation

struct Research {
    // TODO: Can I merge research and researches?
    let level: Int
    let condition: String

    init(_ levels: [Int], _ status: [String], _ type: Int) {
        self.level = levels[type]
        self.condition = status[type]
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
        self.energy = Research(levels, status, 113)
        self.laser = Research(levels, status, 120)
        self.ion = Research(levels, status, 121)
        self.hyperspace = Research(levels, status, 114)
        self.plasma = Research(levels, status, 122)
        self.combustionDrive = Research(levels, status, 115)
        self.impulseDrive = Research(levels, status, 117)
        self.hyperspaceDrive = Research(levels, status, 118)
        self.espionage = Research(levels, status, 106)
        self.computer = Research(levels, status, 108)
        self.astrophysics = Research(levels, status, 124)
        self.researchNetwork = Research(levels, status, 123)
        self.graviton = Research(levels, status, 199)
        self.weapons = Research(levels, status, 109)
        self.shielding = Research(levels, status, 110)
        self.armor = Research(levels, status, 111)

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
