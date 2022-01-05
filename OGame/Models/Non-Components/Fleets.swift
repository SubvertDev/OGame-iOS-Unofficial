//
//  Fleets.swift
//  OGame
//
//  Created by Subvert on 18.09.2021.
//

import Foundation
import UIKit

struct Fleets {
    let id: Int
    let mission: String
    let diplomacy: String
    let playerName: String
    let playerID: Int
    let playerPlanet: String
    let playerPlanetImage: UIImage?
    let enemyName: String?
    let enemyID: Int?
    let enemyPlanet: String?
    let enemyPlanetImage: UIImage?
    let returns: Bool
    let arrivalTime: Int
    let endTime: Int?
    let origin: [Int]
    let destination: [Int]
}
