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
    // TODO: In progress
    static func sendFleet(playerData: PlayerData,
                   mission: Int,
                   id: Int,
                   whereTo: [Int],
                   ships: [BuildingWithAmount],
                   resources: [Int] = [0, 0, 0],
                   speed: Int = 10, // * 10 = %
                   holdingTime: Int = 0) async throws {
        do {
            print("inside send fleet")
            let link = "\(playerData.indexPHP)page=ingame&component=fleetdispatch&cp=\(id)"
            //let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
            let value = try await AF.request(link).serializingData().value
            
            let text = String(data: value, encoding: .ascii)!
            
            print("trying to find token")
            let pattern = "var fleetSendingToken = \"(.*)\""
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            var matches = results.map { nsString.substring(with: $0.range)}
            
            if matches.isEmpty {
                print("didn't find fleetsendingtoken, trying to find token")
                let pattern = "var token = \"(.*)\""
                let regex = try! NSRegularExpression(pattern: pattern, options: [])
                let nsString = text as NSString
                let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                matches = results.map { nsString.substring(with: $0.range)}
            }
            
            matches[0] = matches[0].replacingOccurrences(of: "var token = ", with: "")
            matches[0].removeFirst(2)
            matches[0].removeLast(2)

            guard !matches.isEmpty
            else { throw OGError() }
            
            let match = matches[0]
            print("MATCH: \(match)")
            
            var parameters: Parameters = ["token": match]
            
            for ship in ships {
                if ship.amount == 0 { continue }
                if ship.buildingsID == 202 { continue } // test
                if ship.buildingsID == 204 { continue } // test
                print("ADDING: am\(ship.buildingsID) : \(ship.amount)")
                parameters["am\(ship.buildingsID)"] = ship.amount
            }
                                    
            let additionalParameters = ["galaxy": whereTo[0],
                                        "system": whereTo[1],
                                        "position": whereTo[2],
                                        "type": 1, // make Destination (planet = 1 ) whereTo[3]
                                        "metal": resources[0],
                                        "crystal": resources[1],
                                        "deuterium": resources[2],
                                        "prioMetal": 1,
                                        "prioCrystal": 2,
                                        "prioDeuterium": 3,
                                        "mission": mission,
                                        "speed": speed,
                                        "retreatAfterDefenderRetreat": 0,
                                        "union": 0,
                                        "holdingtime": holdingTime] as [String : Any]
            
            additionalParameters.forEach { parameters[$0] = $1 }
            
            print("COMBINED PARAMETERS: \(parameters)")

            //link = "\(self.indexPHP!)page=ingame&component=fleetdispatch&action=sendFleet&ajax=1&asJson=1"
            //let postResponseValue = try await sessionAF.request(link, method: .post, parameters: parameters, headers: headers).serializingData().value
            //print("SUCCESS: \(postResponseValue)")
            
        } catch {
            throw OGError(message: "Error sending fleet", detailed: error.localizedDescription)
        }
    }
}
