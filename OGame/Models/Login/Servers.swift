//
//  Servers.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import Foundation

// MARK: - Server
struct Servers: Codable {
    let language: String
    let number: Int
    let name: String
    // let playerCount: Int?
    // let playersOnline: Int?
    // let opened: String?
    // let startDate: String?
    // let endDate: String?
    // let serverClosed: Int?
    // let prefered: Int?
    // let signupClosed: Int?
    // let settings: Settings?
}

// MARK: - Settings
// struct Settings: Codable {
//    let aks, fleetSpeed, wreckField: Int?
//    let serverLabel: ServerLabel?
//    let economySpeed, planetFields, universeSize: Int?
//    let serverCategory: ServerCategory?
//    let espionageProbeRaids, premiumValidationGift, debrisFieldFactorShips: Int?
//    let researchDurationDivisor: Double?
//    let debrisFieldFactorDefence: Int?
// }
//
// enum ServerCategory: String, Codable {
//    case balanced = "balanced"
//    case fleeter = "fleeter"
//    case graveyard = "graveyard"
//    case miner = "miner"
// }
//
// enum ServerLabel: String, Codable {
//    case empty = "empty"
//    case graveyard = "graveyard"
//    case new = "new"
// }

struct Index: Codable {
    let url: String
}
