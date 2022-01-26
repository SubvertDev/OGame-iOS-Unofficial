//
//  Buildings.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

struct BuildingWithLevel {
    let name: String
    let metal: Int
    let crystal: Int
    let deuterium: Int
    let image: ImageBundle
    let buildingsID: Int
    let level: Int
    let condition: String
    let timeToBuild: String
}

struct BuildingWithAmount {
    let name: String
    let metal: Int
    let crystal: Int
    let deuterium: Int
    let image: ImageBundle
    let buildingsID: Int
    var amount: Int
    let condition: String
    let timeToBuild: String
}

struct Buildings {
    // Supplies
    static let metalMine = (1, 1, "supplies")
    static let crystalMine = (2, 1, "supplies")
    static let deuteriumMine = (3, 1, "supplies")
    static let solarPlant = (4, 1, "supplies")
    static let fusionPlant = (12, 1, "supplies")
    static let metalStorage = (22, 1, "supplies")
    static let crystalStorage = (23, 1, "supplies")
    static let deuteriumStorage = (24, 1, "supplies")

    // Facilities
    static let roboticsFactory = (14, 1, "facilities")
    static let shipyard = (21, 1, "facilities")
    static let researchLaboratory = (31, 1, "facilities")
    static let allianceDepot = (34, 1, "facilities")
    static let missileSilo = (44, 1, "facilities")
    static let naniteFactory = (15, 1, "facilities")
    static let terraformer = (33, 1, "facilities")
    static let repairDock = (36, 1, "facilities")
    static let moonBase = (41, 1, "facilities")
    static let sensorPhalanx = (42, 1, "facilities")
    static let jumpGate = (43, 1, "facilities")
    
    // Researches
    static let energy = (113, 1, "research")
    static let laser = (120, 1, "research")
    static let ion = (121, 1, "research")
    static let hyperspace = (114, 1, "research")
    static let plasma = (122, 1, "research")
    static let combustionDrive = (115, 1, "research")
    static let impulseDrive = (117, 1, "research")
    static let hyperspaceDrive = (118, 1, "research")
    static let espionage = (106, 1, "research")
    static let computer = (108, 1, "research")
    static let astrophysics = (124, 1, "research")
    static let researchNetwork = (123, 1, "research")
    static let graviton = (199, 1, "research")
    static let weapons = (109, 1, "research")
    static let shielding = (110, 1, "research")
    static let armour = (111, 1, "research")

    // Ships
    static func lightFighter(_ amount: Int = 1) -> (Int, Int, String) { return (204, amount, "shipyard") }
    static func heavyFighter(_ amount: Int = 1) -> (Int, Int, String) { return (205, amount, "shipyard") }
    static func cruiser(_ amount: Int = 1) -> (Int, Int, String) { return (206, amount, "shipyard") }
    static func battleship(_ amount: Int = 1) -> (Int, Int, String) { return (207, amount, "shipyard") }
    static func battlecruiser(_ amount: Int = 1) -> (Int, Int, String) { return (215, amount, "shipyard") }
    static func bomber(_ amount: Int = 1) -> (Int, Int, String) { return (211, amount, "shipyard") }
    static func destroyer(_ amount: Int = 1) -> (Int, Int, String) { return (213, amount, "shipyard") }
    static func deathstar(_ amount: Int = 1) -> (Int, Int, String) { return (214, amount, "shipyard") }
    static func reaper(_ amount: Int = 1) -> (Int, Int, String) { return (218, amount, "shipyard") }
    static func pathfinder(_ amount: Int = 1) -> (Int, Int, String) { return (219, amount, "shipyard") }
    static func smallCargo(_ amount: Int = 1) -> (Int, Int, String) { return (202, amount, "shipyard") }
    static func largeCargo(_ amount: Int = 1) -> (Int, Int, String) { return (203, amount, "shipyard") }
    static func colonyShip(_ amount: Int = 1) -> (Int, Int, String) { return (208, amount, "shipyard") }
    static func recycler(_ amount: Int = 1) -> (Int, Int, String) { return (209, amount, "shipyard") }
    static func espionageProbe(_ amount: Int = 1) -> (Int, Int, String) { return (210, amount, "shipyard") }
    static func solarSatellite(_ amount: Int = 1) -> (Int, Int, String) { return (212, amount, "shipyard") }
    static func crawler(_ amount: Int = 1) -> (Int, Int, String) { return (217, amount, "shipyard") }
    
    // Defences
    static func rocketLauncher(amount: Int = 1) -> (Int, Int, String) { return (401, amount, "defenses") }
    static func lightLaser(amount: Int = 1) -> (Int, Int, String) { return (402, amount, "defenses") }
    static func heavyLaser(amount: Int = 1) -> (Int, Int, String) { return (403, amount, "defenses") }
    static func gaussCannon(amount: Int = 1) -> (Int, Int, String) { return (404, amount, "defenses") }
    static func ionCannon(amount: Int = 1) -> (Int, Int, String) { return (405, amount, "defenses") }
    static func plasmaCannon(amount: Int = 1) -> (Int, Int, String) { return (406, amount, "defenses") }
    static func smallShieldDome(amount: Int = 1) -> (Int, Int, String) { return (407, amount, "defenses") }
    static func largeShieldDome(amount: Int = 1) -> (Int, Int, String) { return (408, amount, "defenses") }
    static func antiBallisticMissiles(amount: Int = 1) -> (Int, Int, String) { return (502, amount, "defenses") }
    static func interplanetaryMissiles(amount: Int = 1) -> (Int, Int, String) { return (503, amount, "defenses") }
}
