//
//  GetFacilities.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGFacilities {
    
    // MARK: - Get Facilities
    static func getFacilitiesWith(playerData: PlayerData) async throws -> [Building] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=facilities&cp=\(playerData.planetID)"
            let data = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: data, encoding: .ascii)!)
            
            let levelsParse = try page.select("span[class=level]").select("[data-value]")
            var levels = [Int]()
            for level in levelsParse {
                levels.append(Int(try level.text())!)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !noScriptCheck(with: page)
            else { throw OGError(message: "Not logged in", detailed: "Facilities login check failed") }
            
            let facilities = Facilities(levels, technologyStatus)
            let facilitiesCells = FacilityCell(with: facilities)
            
            var buildingDataModel: [Building] = []
            
            for building in facilitiesCells.facilityBuildings {
                let buildTime = OGBuildTime.getBuildingTimeOfflineWith(playerData: playerData, buildingWithLevel: building)
                let newBuilding = Building(name: building.name,
                                           metal: building.metal,
                                           crystal: building.crystal,
                                           deuterium: building.deuterium,
                                           image: (available: building.image.available,
                                                   unavailable: building.image.unavailable,
                                                   disabled: building.image.disabled),
                                           buildingsID: building.buildingsID,
                                           levelOrAmount: building.level,
                                           condition: building.condition,
                                           timeToBuild: buildTime)
                buildingDataModel.append(newBuilding)
            }
            return buildingDataModel
            
        } catch {
            throw OGError(message: "Facilities network request failed", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Get Main Facilities Levels
    func getMainFacilitiesLevels(indexPHP: String, planetID: Int) async throws -> [Int] {
        do {
            let link = "\(indexPHP)page=ingame&component=facilities&cp=\(planetID)"
            let data = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: data, encoding: .ascii)!)
            
            let levelsParse = try page.select("span[class=level]").select("[data-value]")
            var levels = [Int]()
            for level in levelsParse {
                levels.append(Int(try level.text())!)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !noScriptCheck(with: page)
            else { throw OGError(message: "Not logged in", detailed: "Facilities login check failed") }
            
            let facilitiesObject = Facilities(levels, technologyStatus)
            
            let roboticsFactoryLevel = facilitiesObject.roboticsFactory.level
            let naniteFactoryLevel = facilitiesObject.naniteFactory.level
            let researchLabLevel = facilitiesObject.researchLaboratory.level
            let shipyardLevel = facilitiesObject.shipyard.level
            
            return [roboticsFactoryLevel,
                    naniteFactoryLevel,
                    researchLabLevel,
                    shipyardLevel]
            
        } catch {
            throw OGError(message: "Facilities levels check request failed", detailed: error.localizedDescription)
        }
    }
}
