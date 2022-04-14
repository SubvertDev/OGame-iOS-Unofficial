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

    init(version: String, speed: Speed, donut: Donut) {
        self.version = version
        self.speed = speed
        self.donut = donut
    }
}

struct Speed {
    let universe: Int
    let peacefulFleet: Int
    let warFleet: Int
    let holdingFleet: Int

    init(universe: Int, peaceSpeed: Int, warSpeed: Int, holdingSpeed: Int ) {
        self.universe = universe
        self.peacefulFleet = peaceSpeed
        self.warFleet = warSpeed
        self.holdingFleet = holdingSpeed
    }
}

struct Donut {
    let galaxy: Bool
    let system: Bool

    init(galaxy: Bool, system: Bool) {
        self.galaxy = galaxy
        self.system = system
    }
}
