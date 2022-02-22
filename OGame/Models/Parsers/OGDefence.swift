//
//  OGDefence.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGDefence {
    
    // MARK: - Get Defences
    static func getDefencesWith(playerData: PlayerData) async throws -> [Building] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=defenses&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let defencesParse = try page.select("[class=amount]").select("[data-value]") // *=amount for targetamount
            var defencesAmount = [Int]()
            for defence in defencesParse {
                defencesAmount.append(Int(try defence.text())!)
            }
            
            let technologyStatusParse = try page.select("li[class*=technology]")
            var technologyStatus = [String]()
            for status in technologyStatusParse {
                technologyStatus.append(try status.attr("data-status"))
            }
            
            guard !defencesAmount.isEmpty else {
                throw OGError(message: "Not logged in", detailed: "Defences login check failed")
            }
            
            let defences = Defences(defencesAmount, technologyStatus)
            let defencesCells = DefenceCell(with: defences)
            
            var buildingDataModel: [Building] = []
            
            for building in defencesCells.defenceTechnologies {
                let buildTime = OGBuildTime.getBuildingTimeOfflineWith(playerData: playerData, buildingWithAmount: building)
                let newBuilding = Building(name: building.name,
                                           metal: building.metal,
                                           crystal: building.crystal,
                                           deuterium: building.deuterium,
                                           image: (available: building.image.available,
                                                   unavailable: building.image.unavailable,
                                                   disabled: building.image.disabled),
                                           buildingsID: building.buildingsID,
                                           levelOrAmount: building.amount,
                                           condition: building.condition,
                                           timeToBuild: buildTime)
                buildingDataModel.append(newBuilding)
            }
            return buildingDataModel
            
        } catch {
            throw OGError(message: "Defences network error", detailed: error.localizedDescription)
        }
    }
}
