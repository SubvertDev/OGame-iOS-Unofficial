//
//  Ships.swift
//  OGame
//
//  Created by Subvert on 30.05.2021.
//

import Foundation

struct Ship {
    // TODO: Merge Ship and Ships?
    let amount: Int
    var condition: String

    init(_ amount: [Int], _ status: [String], _ type: Int) {
        self.amount = amount[type]
        self.condition = status[type]
    }
}

struct Ships {
    let lightFighter: Ship
    let heavyFighter: Ship
    let cruiser: Ship
    let battleship: Ship
    let battlecruiser: Ship
    let bomber: Ship
    let destroyer: Ship
    let deathstar: Ship
    let reaper: Ship
    let pathfinder: Ship
    let smallCargo: Ship
    let largeCargo: Ship
    let colonyShip: Ship
    let recycler: Ship
    let espionageProbe: Ship
    let solarSatellite: Ship
    let crawler: Ship // TODO: Fix crawler moon stuff

    let allShips: [Ship]

    init(_ ships: [Int], _ status: [String]) {
        self.lightFighter = Ship(ships, status, 204)
        self.heavyFighter = Ship(ships, status, 205)
        self.cruiser = Ship(ships, status, 206)
        self.battleship = Ship(ships, status, 207)
        self.battlecruiser = Ship(ships, status, 215)
        self.bomber = Ship(ships, status, 211)
        self.destroyer = Ship(ships, status, 213)
        self.deathstar = Ship(ships, status, 214)
        self.reaper = Ship(ships, status, 218)
        self.pathfinder = Ship(ships, status, 219)
        self.smallCargo = Ship(ships, status, 202)
        self.largeCargo = Ship(ships, status, 203)
        self.colonyShip = Ship(ships, status, 208)
        self.recycler = Ship(ships, status, 209)
        self.espionageProbe = Ship(ships, status, 210)
        self.solarSatellite = Ship(ships, status, 212)
        self.crawler = Ship(ships, status, 217)

        self.allShips = [
            self.lightFighter,
            self.heavyFighter,
            self.cruiser,
            self.battleship,
            self.battlecruiser,
            self.bomber,
            self.destroyer,
            self.deathstar,
            self.reaper,
            self.pathfinder,
            self.smallCargo,
            self.largeCargo,
            self.colonyShip,
            self.recycler,
            self.espionageProbe,
            self.solarSatellite,
            self.crawler
        ]
    }
}

struct Crawler {
    // TODO: Add crawler
    let amount = 0
    let isPossible = false
    let inConstruction = false
}
