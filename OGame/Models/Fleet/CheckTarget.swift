//
//  CheckTarget.swift
//  OGame
//
//  Created by Subvert on 22.01.2022.
//

import Foundation

// MARK: - Target
struct CheckTarget: Codable {
    let additionalFlightSpeedinfo: String
    let shipsData: [String: ShipsDatum]?
    let status: String
    let errors: [TargetError]?
    let orders: [String: Bool]?
    let targetInhabited: Bool?
    let targetIsStrong: Bool?
    let targetIsOutlaw: Bool?
    let targetIsBuddyOrAllyMember: Bool?
    let targetPlayerId: Int?
    let targetPlayerName: String?
    let targetPlayerColorClass: String?
    let targetPlayerRankIcon: String?
    let playerIsOutlaw: Bool?
    let targetPlanet: TargetPlanet?
    let targetOk: Bool?
    let components: [String] // Always empty, don't know the type
    let token: String?
    let newAjaxToken: String
}

// MARK: - ShipsDatum
struct ShipsDatum: Codable {
    let id: Int
    let name: String
    let baseFuelConsumption: Int
    let baseFuelCapacity: Int
    let baseCargoCapacity: Int
    let fuelConsumption: Int
    let baseSpeed: Int
    let speed: Int
    let cargoCapacity: Int
    let fuelCapacity: Int
    let number: Int
    let recycleMode: Int
}

// MARK: - TargetPlanet
struct TargetPlanet: Codable {
    let galaxy: Int
    let system: Int
    let position: Int
    let type: Int
    let name: String
}

// MARK: - TargetError
struct TargetError: Codable {
    let message: String
    let error: Int
}
