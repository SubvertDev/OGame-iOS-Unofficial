//
//  Constants.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import Foundation

struct Price {
    func get(technology: (id: Int, amount: Int, component: String), level: Int = 1) -> [Int] {
        func multiplyResources(resources: [Int], multiplier: Int) -> [Int] {
            var result = [Int]()
            for resource in resources {
                result.append(resource * multiplier)
            }
            return result
        }
        
        func resources(metal: Double = 0.0, crystal: Double = 0.0, deuterium: Double = 0.0) -> [Int] {
            return [Int(metal), Int(crystal), Int(deuterium)]
        }
        
        switch technology.component {
        case "supplies":
            switch technology.id {
            case 1:
                return resources(metal: 60 * pow(1.5, Double(level)), crystal: 15 * pow(1.5, Double(level)))
            case 2:
                return resources(metal: 48 * pow(1.6, Double(level)), crystal: 24 * pow(1.6, Double(level)))
            case 3:
                return resources(metal: 225 * pow(1.5, Double(level)), crystal: 75 * pow(1.5, Double(level)))
            case 4:
                return resources(metal: 75 * pow(1.5, Double(level)), crystal: 30 * pow(1.5, Double(level)))
            case 12:
                return resources(metal: 900 * pow(1.8, Double(level)), crystal: 360 * pow(1.8, Double(level)), deuterium: 180 * pow(1.8, Double(level)))
            case 22:
                return resources(metal: 1000 * pow(2, Double(level)))
            case 23:
                return resources(metal: 1000 * pow(2, Double(level)), crystal: 500 * pow(2, Double(level)))
            case 24:
                return resources(metal: 1000 * pow(2, Double(level)), crystal: 1000 * pow(2, Double(level)))
            case 212:
                return multiplyResources(resources: [0, 2000, 500], multiplier: technology.1)
            case 217:
                return multiplyResources(resources: [2000, 2000, 1000], multiplier: technology.1)
            default:
                return resources()
            }
            
        case "facilities":
            switch technology.id {
            case 14:
                return resources(metal: 400 * pow(2, Double(level)), crystal: 120 * pow(2, Double(level)), deuterium: 200 * pow(2, Double(level)))
            case 21:
                return resources(metal: 200 * pow(2, Double(level)), crystal: 100 * pow(2, Double(level)), deuterium: 50 * pow(2, Double(level)))
            case 31:
                return resources(metal: 200 * pow(2, Double(level)), crystal: 400 * pow(2, Double(level)), deuterium: 200 * pow(2, Double(level)))
            case 34:
                return resources(metal: 10000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)))
            case 44:
                return resources(metal: 20000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)), deuterium: 1000 * pow(2, Double(level)))
            case 15:
                return resources(metal: 1000000 * pow(2, Double(level)), crystal: 500000 * pow(2, Double(level)), deuterium: 100000 * pow(2, Double(level)))
            case 33:
                return resources(crystal: 50000 * pow(2, Double(level)), deuterium: 100000 * pow(2, Double(level)))
            case 36:
                return resources(metal: 40 * pow(5, Double(level)), deuterium: 10 * pow(5, Double(level))) // TODO: Is that right?
            case 41:
                return resources(metal: 10000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)), deuterium: 10000 * pow(2, Double(level)))
            case 42:
                return resources(metal: 10000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)), deuterium: 10000 * pow(2, Double(level)))
            case 43:
                return resources(metal: 10000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)), deuterium: 10000 * pow(2, Double(level)))
            default:
                return resources()
            }
            
        case "research":
            switch technology.id {
            case 113:
                return resources(crystal: 800 * pow(2, Double(level)), deuterium: 400 * pow(2, Double(level)))
            case 120:
                return resources(metal: 200 * pow(2, Double(level)), crystal: 100 * pow(2, Double(level)))
            case 121:
                return resources(metal: 1000 * pow(2, Double(level)), crystal: 300 * pow(2, Double(level)), deuterium: 100 * pow(2, Double(level)))
            case 114:
                return resources(crystal: 4000 * pow(2, Double(level)), deuterium: 2000 * pow(2, Double(level)))
            case 122:
                return resources(metal: 2000 * pow(2, Double(level)), crystal: 4000 * pow(2, Double(level)), deuterium: 1000 * pow(2, Double(level)))
            case 115:
                return resources(metal: 400 * pow(2, Double(level)), deuterium: 600 * pow(2, Double(level)))
            case 117:
                return resources(metal: 2000 * pow(2, Double(level)), crystal: 4000 * pow(2, Double(level)), deuterium: 600 * pow(2, Double(level)))
            case 118:
                return resources(metal: 10000 * pow(2, Double(level)), crystal: 20000 * pow(2, Double(level)), deuterium: 6000 * pow(2, Double(level)))
            case 106:
                return resources(metal: 200 * pow(2, Double(level)), crystal: 1000 * pow(2, Double(level)), deuterium: 200 * pow(2, Double(level)))
            case 108:
                return resources(crystal: 400 * pow(2, Double(level)), deuterium: 600 * pow(2, Double(level)))
            case 124:
                return resources(metal: roundToNearest(4000 * pow(1.75, Double(level)), 100), crystal: roundToNearest(8000 * pow(1.75, Double(level)), 100) , deuterium: roundToNearest(4000 * pow(1.75, Double(level)), 100))
            case 123:
                return resources(metal: 240000 * pow(2, Double(level)), crystal: 400000 * pow(2, Double(level)), deuterium: 160000 * pow(2, Double(level)))
            case 109:
                return resources(metal: 800 * pow(2, Double(level)), crystal: 200 * pow(2, Double(level)))
            case 110:
                return resources(metal: 200 * pow(2, Double(level)), crystal: 600 * pow(2, Double(level)))
            case 111:
                return resources(metal: 1000 * pow(2, Double(level)))
            default:
                return resources()
            }
            
        case "shipyard":
            switch technology.id {
            case 204:
                return multiplyResources(resources: [3000, 1000, 0], multiplier: technology.amount)
            case 205:
                return multiplyResources(resources: [6000, 4000, 0], multiplier: technology.amount)
            case 206:
                return multiplyResources(resources: [20000, 7000, 2000], multiplier: technology.amount)
            case 207:
                return multiplyResources(resources: [45000, 15000, 0], multiplier: technology.amount)
            case 215:
                return multiplyResources(resources: [30000, 40000, 15000], multiplier: technology.amount)
            case 211:
                return multiplyResources(resources: [50000, 25000, 15000], multiplier: technology.amount)
            case 213:
                return multiplyResources(resources: [60000, 50000, 15000], multiplier: technology.amount)
            case 214:
                return multiplyResources(resources: [5000000, 4000000, 1000000], multiplier: technology.amount)
            case 218:
                return multiplyResources(resources: [85000, 55000, 20000], multiplier: technology.amount)
            case 219:
                return multiplyResources(resources: [8000, 15000, 8000], multiplier: technology.amount)
            case 202:
                return multiplyResources(resources: [2000, 2000, 0], multiplier: technology.amount)
            case 203:
                return multiplyResources(resources: [6000, 6000, 0], multiplier: technology.amount)
            case 208:
                return multiplyResources(resources: [10000, 20000, 10000], multiplier: technology.amount)
            case 209:
                return multiplyResources(resources: [10000, 6000, 2000], multiplier: technology.amount)
            case 210:
                return multiplyResources(resources: [0, 1000, 0], multiplier: technology.amount)
            case 212:
                return multiplyResources(resources: [0, 2000, 500], multiplier: technology.1)
            case 217:
                return multiplyResources(resources: [2000, 2000, 1000], multiplier: technology.amount)
            default:
                return resources()
            }
            
        case "defences":
            switch technology.id {
            case 401:
                return multiplyResources(resources: [2000, 0, 0], multiplier: technology.amount)
            case 402:
                return multiplyResources(resources: [1500, 500, 0], multiplier: technology.amount)
            case 403:
                return multiplyResources(resources: [6000, 2000, 0], multiplier: technology.amount)
            case 404:
                return multiplyResources(resources: [20000, 15000, 2000], multiplier: technology.amount)
            case 405:
                return multiplyResources(resources: [5000, 3000, 0], multiplier: technology.amount)
            case 406:
                return multiplyResources(resources: [50000, 50000, 30000], multiplier: technology.amount)
            case 407:
                return multiplyResources(resources: [10000, 10000, 0], multiplier: technology.amount)
            case 408:
                return multiplyResources(resources: [50000, 50000, 0], multiplier: technology.amount)
            case 502:
                return multiplyResources(resources: [8000, 2000, 0], multiplier: technology.amount)
            case 503:
                return multiplyResources(resources: [12500, 2500, 10000], multiplier: technology.amount)
            default:
                return resources()
            }
            
        default:
            return resources()
        }
    }
}

private func roundToNearest(_ value: Double, _ toNearest: Double) -> Double {
    return round(value / toNearest) * toNearest
}
