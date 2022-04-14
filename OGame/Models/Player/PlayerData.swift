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
    let universeInfo: UniverseInfo
    
    var planet: String
    var planetID: Int
    let playerName: String
    let playerID: Int
    
    let rank: Int
    let planetNames: [String]
    let planetIDs: [Int]
    let moonNames: [String]
    let moonIDs: [Int]
    let characterClass: CharacterClass
    let officers: Officers
    
    var currentPlanetIndex = 0
    let planetImages: [UIImage]
    let moonImages: [UIImage?]
    var celestials: [Celestial]
    
    var factoryLevels: [FactoryLevels]
}
