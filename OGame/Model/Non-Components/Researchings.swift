//
//  Researchings.swift
//  OGame
//
//  Created by Subvert on 27.05.2021.
//

import Foundation

struct Researchings {
    let energy = (113, 1, "research")
    let laser = (120, 1, "research")
    let ion = (121, 1, "research")
    let hyperspace = (114, 1, "research")
    let plasma = (122, 1, "research")
    let combustionDrive = (115, 1, "research")
    let impulseDrive = (117, 1, "research")
    let hyperspaceDrive = (118, 1, "research")
    let espionage = (106, 1, "research")
    let computer = (108, 1, "research")
    let astrophysics = (124, 1, "research")
    let researchNetwork = (123, 1, "research")
    let graviton = (199, 1, "research")
    let weapons = (109, 1, "research")
    let shielding = (110, 1, "research")
    let armor = (111, 1, "research")

    static func isResearch(_ researches: (Int, Int, String)) -> Bool {
        return researches.2 == "research" ? true : false
    }
}
