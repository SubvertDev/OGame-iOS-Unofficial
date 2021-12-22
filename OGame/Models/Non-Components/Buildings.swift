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
    let image: (available: UIImage?,
                unavailable: UIImage?,
                disabled: UIImage?)
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
    let image: (available: UIImage?,
                unavailable: UIImage?,
                disabled: UIImage?)
    let buildingsID: Int
    let amount: Int
    let condition: String
    let timeToBuild: String
}

struct Buildings {
    let metalMine = (1, 1, "supplies")
    let crystalMine = (2, 1, "supplies")
    let deuteriumMine = (3, 1, "supplies")
    let solarPlant = (4, 1, "supplies")
    let fusionPlant = (12, 1, "supplies")
    // sattelite
    // crawler
    let metalStorage = (22, 1, "supplies")
    let crystalStorage = (23, 1, "supplies")
    let deuteriumStorage = (24, 1, "supplies")

    static func isSupplies(_ supplies: (Int, Int, String)) -> Bool {
        return supplies.2 == "supplies" ? true : false
    }

    let roboticsFactory = (14, 1, "facilities")
    let shipyard = (21, 1, "facilities")
    let researchLaboratory = (31, 1, "facilities")
    let allianceDepot = (34, 1, "facilities")
    let missileSilo = (44, 1, "facilities")
    let naniteFactory = (15, 1, "facilities")
    let terraformer = (33, 1, "facilities")
    let repairDock = (36, 1, "facilities")
    let moonBase = (41, 1, "facilities")
    let sensorPhalanx = (42, 1, "facilities")
    let jumpGate = (43, 1, "facilities")

    static func isFacilities(_ facilities: (Int, Int, String)) -> Bool {
        return facilities.2 == "facilities" ? true : false
    }

    func rocketLauncher(amount: Int = 1) -> (Int, Int, String) { return (401, amount, "defenses") }
    func lightLaser(amount: Int = 1) -> (Int, Int, String) { return (402, amount, "defenses") }
    func heavyLaser(amount: Int = 1) -> (Int, Int, String) { return (403, amount, "defenses") }
    func gaussCannon(amount: Int = 1) -> (Int, Int, String) { return (404, amount, "defenses") }
    func ionCannon(amount: Int = 1) -> (Int, Int, String) { return (405, amount, "defenses") }
    func plasmaCannon(amount: Int = 1) -> (Int, Int, String) { return (406, amount, "defenses") }
    func smallShieldDome(amount: Int = 1) -> (Int, Int, String) { return (407, amount, "defenses") }
    func largeShieldDome(amount: Int = 1) -> (Int, Int, String) { return (408, amount, "defenses") }
    func antiBallisticMissiles(amount: Int = 1) -> (Int, Int, String) { return (502, amount, "defenses") }
    func interplanetaryMissiles(amount: Int = 1) -> (Int, Int, String) { return (503, amount, "defenses") }

    static func isDefenses(_ defenses: (Int, Int, String)) -> Bool {
        return defenses.2 == "defenses" ? true : false
    }
}
