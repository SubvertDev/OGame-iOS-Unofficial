//
//  Fleets.swift
//  OGame
//
//  Created by Subvert on 18.09.2021.
//

import Foundation

struct Fleets {
    let id: Int
    let mission: Int
    let diplomacy: String
    let playerName: String
    let playerID: Int
    let returns: Bool
    let arrivalTime: Int
    let endTime: Int?
    let origin: [Int]
    let destination: [Int]
}
