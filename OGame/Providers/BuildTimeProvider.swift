//
//  BuildTimeProvider.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation

final class BuildTimeProvider {
    
    // MARK: - Get Building Time (level)
    static func getBuildingTimeOfflineWith(player: PlayerData, buildingWithLevel: BuildingWithLevelData) -> String {
        let resources = buildingWithLevel.metal + buildingWithLevel.crystal
        let robotics = 1 + player.factoryLevels[player.currentPlanetIndex].roboticsFactoryLevel
        let research = 1 + player.factoryLevels[player.currentPlanetIndex].researchLabLevel
        let nanites = NSDecimalNumber(decimal: pow(2, player.factoryLevels[player.currentPlanetIndex].naniteFactoryLevel))
        let speed = getUniverseInfo(player).speed.universe
        
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
    
    // MARK: - Get Building Time (amount)
    static func getBuildingTimeOfflineWith(player: PlayerData, buildingWithAmount: BuildingWithAmountData) -> String {
        let resources = buildingWithAmount.metal + buildingWithAmount.crystal
        let shipyard = 1 + player.factoryLevels[player.currentPlanetIndex].shipyardLevel
        let nanites = NSDecimalNumber(decimal: pow(2, player.factoryLevels[player.currentPlanetIndex].naniteFactoryLevel))
        let speed = getUniverseInfo(player).speed.universe
        
        let time = Int((Double(resources) / Double((2500 * shipyard * Int(truncating: nanites) * speed))) * 3600)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(time)) ?? "nil"
    }
    
    // MARK: - Get Universe Info
    static private func getUniverseInfo(_ playerData: PlayerData) -> UniverseInfo {
        do {
            let version = try playerData.doc.select("[name=ogame-version]").get(0).attr("content")
            let universe = Int(try playerData.doc.select("[name=ogame-universe-speed]").get(0).attr("content")) ?? 0
            let fleetSpeedPeaceful = Int(try playerData.doc.select("[name=ogame-universe-speed-fleet-peaceful]").get(0).attr("content")) ?? 0
            let fleetSpeedWar = Int(try playerData.doc.select("[name=ogame-universe-speed-fleet-war]").get(0).attr("content")) ?? 0
            let fleetSpeedHolding = Int(try playerData.doc.select("[name=ogame-universe-speed-fleet-holding]").get(0).attr("content")) ?? 0
            let speed = Speed(universe: universe,
                              peacefulFleet: fleetSpeedPeaceful,
                              warFleet: fleetSpeedWar,
                              holdingFleet: fleetSpeedHolding)
            
            let galaxyString = Int(try playerData.doc.select("[name=ogame-donut-galaxy]").get(0).attr("content")) ?? 0
            let galaxy = galaxyString == 1 ? true : false
            let systemString = Int(try playerData.doc.select("[name=ogame-donut-system]").get(0).attr("content")) ?? 0
            let system = systemString == 1 ? true : false
            let donut = Donut(galaxy: galaxy, system: system)
            
            return UniverseInfo(version: version, speed: speed, donut: donut)
            
        } catch {
            return UniverseInfo(version: "-1",
                                speed: Speed(universe: 0, peacefulFleet: 0, warFleet: 0, holdingFleet: 0),
                                donut: Donut(galaxy: false, system: false))
        }
    }
}
