//
//  Supply.swift
//  OGame
//
//  Created by Subvert on 21.05.2021.
//

import Foundation

struct Supply {
    // TODO: Can I merge Supply and Supplies?
    let level: Int
    let condition: String

    init(_ levels: [Int], _ status: [String], _ type: Int) {
        self.level = levels[type]
        self.condition = status[type]
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

        self.metalMine = Supply(levels, fixedStatus, 0)
        self.crystalMine = Supply(levels, fixedStatus, 1)
        self.deuteriumMine = Supply(levels, fixedStatus, 2)
        self.solarPlant = Supply(levels, fixedStatus, 3)
        self.fusionPlant = Supply(levels, fixedStatus, 4)
        self.metalStorage = Supply(levels, fixedStatus, 5)
        self.crystalStorage = Supply(levels, fixedStatus, 6)
        self.deuteriumStorage = Supply(levels, fixedStatus, 7)

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
