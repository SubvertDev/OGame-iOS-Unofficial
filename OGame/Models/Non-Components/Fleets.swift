//
//  Fleets.swift
//  OGame
//
//  Created by Subvert on 18.09.2021.
//

import Foundation

struct Fleets {
    let id: Int
    let mission: String
    let diplomacy: String
    let playerName: String
    let playerID: Int
    let playerPlanet: String
    let enemyName: String?
    let enemyID: Int?
    let enemyPlanet: String?
    let returns: Bool
    let arrivalTime: Int
    let endTime: Int?
    let origin: [Int]
    let destination: [Int]
}
