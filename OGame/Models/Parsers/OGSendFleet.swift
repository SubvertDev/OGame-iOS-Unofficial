//
//  OGSendFleet.swift
//  OGame
//
//  Created by Subvert on 20.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGSendFleet {
    
    static var currentToken: String?
    
    // MARK: - Send Fleet
    static func sendFleet(player: PlayerData,
                          mission: Mission,
                          whereTo: Coordinates,
                          ships: [Building],
                          resources: [Int] = [0, 0, 0],
                          speed: Int = 10, // * 10 = %
                          holdingTime: Int = 0) async throws -> SendTarget {
        do {
            let link = "\(player.indexPHP)page=ingame&component=fleetdispatch&cp=\(player.planetID)"
            let value = try await AF.request(link).serializingData().value
            try await getToken(from: value)
            
            var shipParameters: Parameters = [:]
            for ship in ships where ship.levelOrAmount != 0 {
                shipParameters["am\(ship.buildingsID)"] = ship.levelOrAmount
            }
                        
            var parameters: Parameters = ["token": currentToken!,
                                          "galaxy": whereTo.galaxy,
                                          "system": whereTo.system,
                                          "position": whereTo.position,
                                          "type": whereTo.destination.rawValue,
                                          "metal": resources[0],
                                          "crystal": resources[1],
                                          "deuterium": resources[2],
                                          "prioMetal": 1,
                                          "prioCrystal": 2,
                                          "prioDeuterium": 3,
                                          "mission": mission.rawValue,
                                          "speed": speed,
                                          "retreatAfterDefenderRetreat": 0,
                                          "union": 0,
                                          "holdingtime": holdingTime]
            shipParameters.forEach { parameters[$0] = $1 }
            
            let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
            let newLink = "\(player.indexPHP)page=ingame&component=fleetdispatch&action=sendFleet&ajax=1&asJson=1"
            
            let sendFleetResponse = try await AF.request(newLink, method: .post, parameters: parameters, headers: headers).serializingData().value
            let responseJSON = try JSONDecoder().decode(SendTarget.self, from: sendFleetResponse)
            currentToken = responseJSON.newAjaxToken
            return responseJSON
            
        } catch {
            throw OGError(message: "Error sending fleet", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Check Target
    static func checkTarget(player: PlayerData,
                            whereTo: Coordinates,
                            ships: [Building]? = nil) async throws -> CheckTarget {
        do {
            let link = "\(player.indexPHP)page=ingame&component=fleetdispatch&cp=\(player.planetID)"
            let value = try await AF.request(link).serializingData().value
            try await getToken(from: value)
            
            let checkLink = "\(player.indexPHP)page=ingame&component=fleetdispatch&action=checkTarget&ajax=1&asJson=1"
            let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
            var targetParameters: Parameters = ["galaxy": whereTo.galaxy,
                                                "system": whereTo.system,
                                                "position": whereTo.position,
                                                "type": whereTo.destination.rawValue,
                                                "token": "\(currentToken ?? "")",
                                                "union": 0]
            if let ships = ships {
                var shipsParameters: Parameters = [:]
                for ship in ships where ship.levelOrAmount != 0 {
                    shipsParameters["am\(ship.buildingsID)"] = ship.levelOrAmount
                }
                shipsParameters.forEach { targetParameters[$0] = $1 }
            }
            
            let checkFleetResponse = try await AF.request(checkLink, method: .post, parameters: targetParameters, headers: headers).serializingData().value
            let targetJSON = try JSONDecoder().decode(CheckTarget.self, from: checkFleetResponse)
            currentToken = targetJSON.newAjaxToken
            
            return targetJSON
            
        } catch {
            throw OGError(message: "Check target error", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Get Token
    static private func getToken(from data: Data) async throws {
        do {
            let text = String(data: data, encoding: .ascii)!
            
            let pattern = "var fleetSendingToken = \"(.*)\""
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            var matches = results.map { nsString.substring(with: $0.range)}
            
            if matches.isEmpty {
                let pattern = "var token = \"(.*)\""
                let regex = try! NSRegularExpression(pattern: pattern, options: [])
                let nsString = text as NSString
                let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                matches = results.map { nsString.substring(with: $0.range)}
            }
            
            guard !matches.isEmpty else { throw OGError() }

            matches[0] = matches[0].replacingOccurrences(of: "var token = ", with: "") // fatal error if no check on relogin
            matches[0].removeFirst(1)
            matches[0].removeLast(1)
            
            self.currentToken = matches[0]
            
        } catch {
            throw OGError(message: "Get token error", detailed: error.localizedDescription)
        }
    }
}
