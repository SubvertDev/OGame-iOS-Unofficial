//
//  UniverseInfo.swift
//  OGame
//
//  Created by Subvert on 19.07.2021.
//

import Foundation

struct UniverseInfo {
    let version: String
    let speed: Speed
    let donut: Donut
}

struct Speed {
    let universe: Int
    let peacefulFleet: Int
    let warFleet: Int
    let holdingFleet: Int
}

struct Donut {
    let galaxy: Bool
    let system: Bool
}
