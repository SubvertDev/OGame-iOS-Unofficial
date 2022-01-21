//
//  OGBuildTime.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation

class OGBuildTime {
    
    static func getBuildingTimeOfflineWith(playerData: PlayerData, buildingWithLevel: BuildingWithLevelData) -> String {
        let resources = buildingWithLevel.metal + buildingWithLevel.crystal
        let robotics = 1 + playerData.roboticsFactoryLevel
        let research = 1 + playerData.researchLabLevel
        let nanites = NSDecimalNumber(decimal: pow(2, playerData.naniteFactoryLevel))
        let speed = getServerInfo(playerData).speed.universe
        
        var time = 0
        if buildingWithLevel.level < 5 && !(106...199).contains(buildingWithLevel.buildingsID) {
            time = Int(round((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * Double(2) / Double(7 - buildingWithLevel.level) * 3600))
        } else if (106...199).contains(buildingWithLevel.buildingsID) {
            time = Int(round((Double(resources) / Double((2000 * research * speed))) * 3600))
        } else {
            time = Int(round((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * 3600))
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(time)) ?? "nil"
    }
    
    static func getBuildingTimeOfflineWith(playerData: PlayerData, buildingWithAmount: BuildingWithAmountData) -> String {
        let resources = buildingWithAmount.metal + buildingWithAmount.crystal
        let shipyard = 1 + playerData.shipyardLevel
        let nanites = NSDecimalNumber(decimal: pow(2, playerData.naniteFactoryLevel))
        let speed = getServerInfo(playerData).speed.universe
        
        let time = Int((Double(resources) / Double((2500 * shipyard * Int(truncating: nanites) * speed))) * 3600)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(time)) ?? "nil"
    }
    
    static private func getServerInfo(_ playerData: PlayerData) -> Server {
        do {
            let version = try playerData.doc.select("[name=ogame-version]").get(0).attr("content")
            
            let universe = Int(try playerData.doc.select("[name=ogame-universe-speed]").get(0).attr("content")) ?? -1
            let fleet = Int(try playerData.doc.select("[name=ogame-universe-speed-fleet-peaceful]").get(0).attr("content")) ?? -1
            let speed = Speed(universe: universe, fleet: fleet)
            
            let galaxyString = Int(try playerData.doc.select("[name=ogame-donut-galaxy]").get(0).attr("content")) ?? 0
            let galaxy = galaxyString == 1 ? true : false
            let systemString = Int(try playerData.doc.select("[name=ogame-donut-system]").get(0).attr("content")) ?? 0
            let system = systemString == 1 ? true : false
            let donut = Donut(galaxy: galaxy, system: system)
            
            return Server(version: version, speed: speed, donut: donut)
            
        } catch {
            return Server(version: "-1", speed: Speed(universe: -1, fleet: -1), donut: Donut(galaxy: false, system: false))
        }
    }
}
