//
//  OGOverview.swift
//  OGame
//
//  Created by Subvert on 17.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

final class OverviewProvider {
    
    // MARK: - Get Overview
    func getOverviewWith(playerData: PlayerData) async throws -> [Overview?] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=overview"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let noScript = try page.select("noscript").text()
            guard noScript != "You need to enable JavaScript to run this app."
            else { throw OGError(message: "Not logged in", detailed: "Overview login check failed") }
            
            var overviewInfo: [Overview?] = [nil, nil, nil]
            
            let buildingsParseCheck = try page.select("[id=productionboxbuildingcomponent]").get(0).select("tr").count
            if buildingsParseCheck != 1 {
                let buildingsParse = try page.select("[id=productionboxbuildingcomponent]").get(0)
                let buildingName = try buildingsParse.select("tr").get(0).select("th").get(0).text()
                let buildingLevel = try buildingsParse.select("tr").get(1).select("td").get(1).select("span").text()
                
                overviewInfo[0] = Overview(buildingName: buildingName, upgradeLevel: buildingLevel)
            }
            
            let researchParseCheck = try page.select("[id=productionboxresearchcomponent]").get(0).select("tr").count
            if researchParseCheck != 1 {
                let researchParse = try page.select("[id=productionboxresearchcomponent]").get(0)
                let researchName = try researchParse.select("tr").get(0).select("th").get(0).text()
                let researchLevel = try researchParse.select("tr").get(1).select("td").get(1).select("span").text()
                
                overviewInfo[1] = Overview(buildingName: researchName, upgradeLevel: researchLevel)
            }
            
            let shipyardParseCheck = try page.select("[id=productionboxshipyardcomponent]").get(0).select("tr").count
            if shipyardParseCheck != 1 {
                let shipyardParse = try page.select("[id=productionboxshipyardcomponent]").get(0)
                let shipyardName = try shipyardParse.select("tr").get(0).select("th").get(0).text()
                let shipyardCount = try shipyardParse.select("tr").get(1).select("td").get(0).select("div").get(1).text()
                
                overviewInfo[2] = Overview(buildingName: shipyardName, upgradeLevel: shipyardCount)
            }
            return overviewInfo
            
        } catch {
            throw OGError(message: "Overview network request failed", detailed: error.localizedDescription)
        }
    }
}
