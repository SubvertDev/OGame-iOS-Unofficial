//
//  Ships.swift
//  OGame
//
//  Created by Subvert on 30.05.2021.
//

import Foundation

struct Ships {
    
    struct Ship {
        let amount: Int
        let condition: String

        init(_ amount: Int, _ status: String, _ type: Int) {
            self.amount = amount
            self.condition = status
        }
    }
    
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
    let crawler: Ship

    var allShips: [Ship]

    init(_ ships: [Int], _ status: [String]) {
        self.lightFighter = Ship(ships[0], status[0], 204)
        self.heavyFighter = Ship(ships[1], status[1], 205)
        self.cruiser = Ship(ships[2], status[2], 206)
        self.battleship = Ship(ships[3], status[3], 207)
        self.battlecruiser = Ship(ships[4], status[4], 215)
        self.bomber = Ship(ships[5], status[5], 211)
        self.destroyer = Ship(ships[6], status[6], 213)
        self.deathstar = Ship(ships[7], status[7], 214)
        self.reaper = Ship(ships[8], status[8], 218)
        self.pathfinder = Ship(ships[9], status[9], 219)
        self.smallCargo = Ship(ships[10], status[10], 202)
        self.largeCargo = Ship(ships[11], status[11], 203)
        self.colonyShip = Ship(ships[12], status[12], 208)
        self.recycler = Ship(ships[13], status[13], 209)
        self.espionageProbe = Ship(ships[14], status[14], 210)
        self.solarSatellite = Ship(ships[15], status[15], 212)

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
            self.solarSatellite
        ]
        
        if status.count == 17 { // Planet
            self.crawler = Ship(ships[16], status[16], 217)
            allShips.append(crawler)
        } else { // Moon 16
            self.crawler = Ship(0, "off", 217)
        }
    }
}
