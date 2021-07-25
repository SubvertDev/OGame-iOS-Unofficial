//
//  Server.swift
//  OGame
//
//  Created by Subvert on 19.07.2021.
//

import Foundation

struct Server {
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
    let fleet: Int

    init(universe: Int, fleet: Int) {
        self.universe = universe
        self.fleet = fleet
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
