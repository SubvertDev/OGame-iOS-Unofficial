//
//  Shipings.swift
//  OGame
//
//  Created by Subvert on 30.05.2021.
//

import Foundation

struct Shipings {
    
    func lightFighter(_ amount: Int = 1) -> (Int, Int, String) { return (204, amount, "shipyard") }
    func heavyFighter(_ amount: Int = 1) -> (Int, Int, String) { return (205, amount, "shipyard") }
    func cruiser(_ amount: Int = 1) -> (Int, Int, String) { return (206, amount, "shipyard") }
    func battleship(_ amount: Int = 1) -> (Int, Int, String) { return (207, amount, "shipyard") }
    func battlecruiser(_ amount: Int = 1) -> (Int, Int, String) { return (215, amount, "shipyard") }
    func bomber(_ amount: Int = 1) -> (Int, Int, String) { return (211, amount, "shipyard") }
    func destroyer(_ amount: Int = 1) -> (Int, Int, String) { return (213, amount, "shipyard") }
    func deathstar(_ amount: Int = 1) -> (Int, Int, String) { return (214, amount, "shipyard") }
    func reaper(_ amount: Int = 1) -> (Int, Int, String) { return (218, amount, "shipyard") }
    func pathfinder(_ amount: Int = 1) -> (Int, Int, String) { return (219, amount, "shipyard") }
    func smallCargo(_ amount: Int = 1) -> (Int, Int, String) { return (202, amount, "shipyard") }
    func largeCargo(_ amount: Int = 1) -> (Int, Int, String) { return (203, amount, "shipyard") }
    func colonyShip(_ amount: Int = 1) -> (Int, Int, String) { return (208, amount, "shipyard") }
    func recycler(_ amount: Int = 1) -> (Int, Int, String) { return (209, amount, "shipyard") }
    func espionageProbe(_ amount: Int = 1) -> (Int, Int, String) { return (210, amount, "shipyard") }
    func solarSatellite(_ amount: Int = 1) -> (Int, Int, String) { return (212, amount, "shipyard") }
    func crawler(_ amount: Int = 1) -> (Int, Int, String) { return (217, amount, "shipyard") }
    
    static func isShip(_ ships: (Int, Int, String)) -> Bool {
        return ships.2 == "shipyard" ? true : false
    }
    
    // ship name
    
    // ship amount
    
    // ship id
}
