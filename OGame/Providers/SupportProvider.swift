//
//  SupportProvider.swift
//  OGame
//
//  Created by Subvert on 17.01.2022.
//

import Foundation
import SwiftSoup

final class SupportProvider {
    
    // MARK: - Get Character Class
    func getCharacterClassWith(playerData: PlayerData) -> String {
        if let character = try? playerData.doc.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last! {
            return character
        } else {
            return "error"
        }
    }
    
    // MARK: - Get ID by planet name
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
    
    // MARK: - Get Planet IDs
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

    // MARK: - Get Planet Names
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

// MARK: - NoScriptCheck
func noScriptCheck(with page: Document) -> Bool {
    let noScript = try? page.select("noscript").text()
    return noScript == "You need to enable JavaScript to run this app." ? true : false
}
