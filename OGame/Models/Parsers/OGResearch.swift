//
//  OGResearch.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGResearch {
    
    static func getResearchesWith(playerData: PlayerData) async throws -> [BuildingWithLevel] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=research&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let levelsParse = try page.select("span[class=level]").select("[data-value]")
            var levels = [Int]()
            for level in levelsParse {
                levels.append(Int(try level.text().components(separatedBy: "(")[0]) ?? -1)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !levels.isEmpty && !technologyStatus.isEmpty
            else { throw OGError(message: "Not logged in", detailed: "Research login check failed") }
            
            let researches = Researches(levels, technologyStatus)
            let researchesCells = ResearchCell(with: researches)
            
            var buildingDataModel: [BuildingWithLevel] = []
            
            for building in researchesCells.researchTechnologies {
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
            throw OGError(message: "Research network error", detailed: error.localizedDescription)
        }
    }
}
