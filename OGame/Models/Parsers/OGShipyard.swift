//
//  OGShipyard.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGShipyard {
    
    // MARK: Get Ships
    static func getShipsWith(playerData: PlayerData) async throws -> [BuildingWithAmount] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=shipyard&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let shipsParse = try page.select("[class=amount]").select("[data-value]") // *=amount for targetamount
            var shipsAmount = [Int]()
            for ship in shipsParse {
                shipsAmount.append(Int(try ship.text())!)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !shipsAmount.isEmpty else {
                throw OGError(message: "Not logged in", detailed: "Ships login check failed")
            }
            
            let ships = Ships(shipsAmount, technologyStatus)
            let shipsCells = ShipsCell(with: ships)
            
            var buildingDataModel: [BuildingWithAmount] = []
            
            for building in shipsCells.shipsTechnologies {
                let buildTime = OGBuildTime.getBuildingTimeOfflineWith(playerData: playerData, buildingWithAmount: building)
                let newBuilding = BuildingWithAmount(name: building.name,
                                                     metal: building.metal,
                                                     crystal: building.crystal,
                                                     deuterium: building.deuterium,
                                                     image: (available: building.image.available,
                                                             unavailable: building.image.unavailable,
                                                             disabled: building.image.disabled),
                                                     buildingsID: building.buildingsID,
                                                     amount: building.amount,
                                                     condition: building.condition,
                                                     timeToBuild: buildTime)
                buildingDataModel.append(newBuilding)
            }
            return buildingDataModel
            
        } catch {
            throw OGError(message: "Ships network error", detailed: error.localizedDescription)
        }
    }
}
