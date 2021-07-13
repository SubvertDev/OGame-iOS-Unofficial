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
        self.lightFighter = Ship(ships, status, 0)
        self.heavyFighter = Ship(ships, status, 1)
        self.cruiser = Ship(ships, status, 2)
        self.battleship = Ship(ships, status, 3)
        self.battlecruiser = Ship(ships, status, 4)
        self.bomber = Ship(ships, status, 5)
        self.destroyer = Ship(ships, status, 6)
        self.deathstar = Ship(ships, status, 7)
        self.reaper = Ship(ships, status, 8)
        self.pathfinder = Ship(ships, status, 9)
        self.smallCargo = Ship(ships, status, 10)
        self.largeCargo = Ship(ships, status, 11)
        self.colonyShip = Ship(ships, status, 12)
        self.recycler = Ship(ships, status, 13)
        self.espionageProbe = Ship(ships, status, 14)
        self.solarSatellite = Ship(ships, status, 15)
        self.crawler = Ship(ships, status, 16)
        
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
