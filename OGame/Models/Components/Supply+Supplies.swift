//
//  Supply.swift
//  OGame
//
//  Created by Subvert on 21.05.2021.
//

import Foundation

struct Supply {
    let level: Int
    let condition: String

    init(_ level: Int, _ status: String, _ type: Int) {
        self.level = level
        self.condition = status
    }
}

struct Supplies {
    let metalMine: Supply
    let crystalMine: Supply
    let deuteriumMine: Supply
    let solarPlant: Supply
    let fusionPlant: Supply
    let metalStorage: Supply
    let crystalStorage: Supply
    let deuteriumStorage: Supply

    let allSupplies: [Supply]

    init(_ levels: [Int], _ status: [String]) {
        // TODO: Add Solar Sattelite and Crawler
        var fixedStatus = status
        fixedStatus.removeSubrange(5...6)

        self.metalMine = Supply(levels[0], fixedStatus[0], 1)
        self.crystalMine = Supply(levels[1], fixedStatus[1], 2)
        self.deuteriumMine = Supply(levels[2], fixedStatus[2], 3)
        self.solarPlant = Supply(levels[3], fixedStatus[3], 4)
        self.fusionPlant = Supply(levels[4], fixedStatus[4], 12)
        self.metalStorage = Supply(levels[5], fixedStatus[5], 22)
        self.crystalStorage = Supply(levels[6], fixedStatus[6], 23)
        self.deuteriumStorage = Supply(levels[7], fixedStatus[7], 24)

        self.allSupplies = [
            self.metalMine,
            self.crystalMine,
            self.deuteriumMine,
            self.solarPlant,
            self.fusionPlant,
            self.metalStorage,
            self.crystalStorage,
            self.deuteriumStorage
        ]
    }
}
