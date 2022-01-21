//
//  OGSupport.swift
//  OGame
//
//  Created by Subvert on 17.01.2022.
//

import Foundation
import SwiftSoup

class OGSupport {
    
    func getCharacterClassWith(playerData: PlayerData) -> String {
        if let character = try? playerData.doc.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last! {
            return character
        } else {
            return "error"
        }
    }
    
    func getIdByPlanetNameWith(_ name: String, playerData: PlayerData) -> Int {
        var found: Int?

        for (planetName, id) in zip(getPlanetNamesWith(playerData: playerData),
                                    getPlanetIDsWith(playerData: playerData)) {
            if planetName == name {
                found = id
            }
        }
        return found!
    }
    
    func getPlanetIDsWith(playerData: PlayerData) -> [Int] {
        do {
            var ids = [Int]()
            let planets = try playerData.doc.select("[class*=smallplanet]")
            for planet in planets {
                let idAttribute = try planet.attr("id")
                let planetID = Int(idAttribute.replacingOccurrences(of: "planet-", with: ""))!
                ids.append(planetID)
            }
            return ids
            
        } catch {
            return [-1]
        }
    }


    func getPlanetNamesWith(playerData: PlayerData) -> [String] {
        do {
            var planetNames = [String]()
            let planets = try playerData.doc.select("[class=planet-name]")
            for planet in planets {
                planetNames.append(try planet.text())
            }
            return planetNames
            
        } catch {
            return ["Error"]
        }
    }
}

func noScriptCheck(with page: Document) -> Bool {
    let noScript = try? page.select("noscript").text()
    if noScript == "You need to enable JavaScript to run this app." {
        return true
    } else {
        return false
    }
}
