//
//  PlayerData.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import SwiftSoup

struct PlayerData {
    let doc: Document
    let indexPHP: String
    let universe: String
    
    var planet: String
    var planetID: Int
    let playerName: String
    let playerID: Int
    
    let rank: Int
    let planetNames: [String]
    let planetIDs: [Int]
    let commander: Bool
    
    var currentPlanetIndex = 0
    let planetImages: [UIImage]
    var celestials: [Celestial]
    
    let roboticsFactoryLevel: Int
    let naniteFactoryLevel: Int
    let researchLabLevel: Int
    let shipyardLevel: Int
}
