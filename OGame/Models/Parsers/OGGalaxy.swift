//
//  OGGalaxy.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGGalaxy {
    
    // MARK: - Get Galaxy
    func getGalaxyWith(coordinates: [Int], playerData: PlayerData) async throws -> [Position?] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=galaxyContent&ajax=1"
            let parameters: Parameters = ["galaxy": coordinates[0], "system": coordinates[1]]
            let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
            
            struct GalaxyResponse: Codable {
                let galaxy: String
            }
            
            let value = try await AF.request(link, method: .post, parameters: parameters, headers: headers).serializingDecodable(GalaxyResponse.self).value
            
            let galaxyInfo = try SwiftSoup.parse(value.galaxy)
            let players = try galaxyInfo.select("[id*=player]")
            let alliances = try galaxyInfo.select("[id*=alliance]")
            
            let imagesParse = try galaxyInfo.select("li").select("[class*=planetTooltip]")
            var images: [String] = []
            for image in imagesParse {
                images.append(try image.attr("class").replacingOccurrences(of: "planetTooltip ", with: ""))
            }
            
            var playerNames = [String: String]()
            var playerRanks = [String: Int]()
            var playerAlliances = [String: String]()
            
            for player in players {
                let nameKey = try player.attr("id").replacingOccurrences(of: "player", with: "")
                let nameValue = try player.select("span").text()
                playerNames[nameKey] = nameValue
                
                let rankKey = try player.attr("id").replacingOccurrences(of: "player", with: "")
                let rankValue = Int(try player.select("a").get(0).text()) ?? 0
                playerRanks[rankKey] = rankValue
            }
            
            for alliance in alliances {
                let allianceKey = try alliance.attr("id").replacingOccurrences(of: "alliance", with: "")
                let allianceValue = try alliance.select("h1").get(0).text()
                playerAlliances[allianceKey] = allianceValue
            }
            
            var planets = [Position?]()
            
            for row in try galaxyInfo.select("#galaxytable .row") {
                let status = try row.attr("class").replacingOccurrences(of: "row ", with: "").replacingOccurrences(of: "_filter", with: "").trimmingCharacters(in: .whitespaces)
                var planetStatus = ""
                var playerID = 0
                
                let staffCheckID = try row.select("[rel~=player[0-9]+]").attr("rel").replacingOccurrences(of: "player", with: "")
                
                if status.contains("empty_filter") {
                    planets.append(nil)
                    continue
                } else if status.count == 0 {
                    if playerRanks[staffCheckID] == -1 {
                        planetStatus = "staff"
                        playerID = Int(staffCheckID)!
                    } else {
                        planetStatus = "you"
                        playerID = playerData.playerID
                        playerNames[String(playerID)] = playerData.playerName
                        playerRanks[String(playerID)] = playerData.rank
                    }
                } else {
                    planetStatus = "\(status[status.startIndex])"
                    
                    let player = try row.select("[rel~=player[0-9]+]").attr("rel")
                    if player.isEmpty {
                        planets.append(nil)
                        continue
                    }
                    
                    playerID = Int(player.replacingOccurrences(of: "player", with: ""))!
                    if playerID == 99999 {
                        planets.append(nil)
                        continue
                    }
                }
                
                let planetPosition = try row.select("[class*=position]").text()
                let planetCoordinates = [coordinates[0], coordinates[1], Int(planetPosition)!, 1]
                let moonPosition = try row.select("[rel*=moon]").attr("rel")
                let allianceID = try row.select("[rel*=alliance]").attr("rel").replacingOccurrences(of: "alliance", with: "")
                let planetName = try row.select("[id~=planet[0-9]+]").select("h1").text().replacingOccurrences(of: "Planet: ", with: "")
                
                var imageString = ""
                let noNilsCount = planets.filter({ $0 != nil}).count
                if noNilsCount == 0 {
                    imageString = images[0]
                } else {
                    imageString = images[noNilsCount]
                }
                
                let position = Position(coordinates: planetCoordinates,
                                        planetName: planetName,
                                        playerName: playerNames[String(playerID)]!,
                                        playerID: playerID,
                                        rank: playerRanks[String(playerID)]!,
                                        status: planetStatus,
                                        moon: moonPosition != "",
                                        alliance: playerAlliances[allianceID],
                                        imageString: imageString)
                planets.append(position)
            }
            return planets
            
        } catch {
            throw OGError(message: "Error getting galaxy data", detailed: error.localizedDescription)
        }
    }
}
