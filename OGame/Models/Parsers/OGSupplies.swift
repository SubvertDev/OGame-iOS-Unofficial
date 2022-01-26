//
//  OGSupply.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGSupplies {
        
    // MARK: - Get Supplies
    static func getSuppliesWith(playerData: PlayerData) async throws -> [BuildingWithLevel] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=supplies&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let levelsParse = try page.select("span[data-value][class=level]") // + [class=amount]
            var levels = [Int]()
            for level in levelsParse {
                levels.append(Int(try level.text())!)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !levels.isEmpty, !technologyStatus.isEmpty
            else { throw OGError(message: "Not logged in", detailed: "Supply login check failed") }
            
            let supplies = Supplies(levels, technologyStatus)
            let supplyCells = ResourceCell(with: supplies)
            
            var buildingDataModel: [BuildingWithLevel] = []
            
            for building in supplyCells.resourceBuildings {
                let buildTime = OGBuildTime.getBuildingTimeOfflineWith(playerData: playerData, buildingWithLevel: building)
                let newBuilding = BuildingWithLevel(name: building.name,
                                                    metal: building.metal,
                                                    crystal: building.crystal,
                                                    deuterium: building.deuterium,
                                                    image: (available: building.image.available,
                                                            unavailable: building.image.unavailable,
                                                            disabled: building.image.disabled),
                                                    buildingsID: building.buildingsID,
                                                    level: building.level,
                                                    condition: building.condition,
                                                    timeToBuild: buildTime)
                buildingDataModel.append(newBuilding)
            }
            return buildingDataModel
            
        } catch {
            throw OGError(message: "Supplies network request failed", detailed: error.localizedDescription)
        }
    }
}
