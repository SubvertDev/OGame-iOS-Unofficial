//
//  Defence+Defences.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import Foundation

struct Defences {
    
    struct Defence {
        let amount: Int
        let condition: String

        init(_ amount: Int, _ status: String, _ type: Int) {
            self.amount = amount
            self.condition = status
        }
    }
    
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
        self.rocketLauncher = Defence(defences[0], status[0], 401)
        self.lightLaser = Defence(defences[1], status[1], 402)
        self.heavyLaser = Defence(defences[2], status[2], 403)
        self.gaussCannon = Defence(defences[3], status[3], 404)
        self.ionCannon = Defence(defences[4], status[4], 405)
        self.plasmaCannon = Defence(defences[5], status[5], 406)
        self.smallShieldDome = Defence(defences[6], status[6], 407)
        self.largeShieldDome = Defence(defences[7], status[7], 408)
        self.antiBallisticMissiles = Defence(defences[8], status[8], 502)
        self.interplanetaryMissiles = Defence(defences[9], status[9], 503)

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
