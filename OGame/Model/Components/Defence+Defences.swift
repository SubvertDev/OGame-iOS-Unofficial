//
//  Defence+Defences.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import Foundation

class Defence {
    
    // TODO: Merge Defence and Defences?
    let amount: Int
    var condition: String
    
    init(_ amount: [Int], _ status: [String], _ type: Int) {
        self.amount = amount[type]
        self.condition = status[type]
    }
}

struct Defences {
    let rocketLauncher: Defence
    let lightLaser: Defence
    let heavyLaser: Defence
    let gaussCannon: Defence
    let ionCannon: Defence
    let plasmaCannon: Defence
    let smallShieldDome: Defence
    let largeShieldDome: Defence
    let antiBallisticMissiles: Defence
    let interplanetaryMissiles: Defence
    
    let allDefences: [Defence]
    
    init(_ defences: [Int], _ status: [String]) {
        self.rocketLauncher = Defence(defences, status, 0)
        self.lightLaser = Defence(defences, status, 1)
        self.heavyLaser = Defence(defences, status, 2)
        self.gaussCannon = Defence(defences, status, 3)
        self.ionCannon = Defence(defences, status, 4)
        self.plasmaCannon = Defence(defences, status, 5)
        self.smallShieldDome = Defence(defences, status, 6)
        self.largeShieldDome = Defence(defences, status, 7)
        self.antiBallisticMissiles = Defence(defences, status, 8)
        self.interplanetaryMissiles = Defence(defences, status, 9)
        
        self.allDefences = [
            self.rocketLauncher,
            self.lightLaser,
            self.heavyLaser,
            self.gaussCannon,
            self.ionCannon,
            self.plasmaCannon,
            self.smallShieldDome,
            self.largeShieldDome,
            self.antiBallisticMissiles,
            self.interplanetaryMissiles
        ]
    }
}
