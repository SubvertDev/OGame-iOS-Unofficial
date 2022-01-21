//
//  ConfigurePlayer.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class ConfigurePlayer {
            
    private var doc: Document?
    
    private var planet: String?
    private var planetID: Int?
    private var playerName: String?
    private var playerID: Int?
    
    private var rank: Int?
    private var planetNames: [String]?
    private var planetIDs: [Int]?
    private var commander: Bool?
    
    private var planetImages: [UIImage]?
    private var celestials: [Celestial]?
    
    private var roboticsFactoryLevel: Int?
    private var naniteFactoryLevel: Int?
    private var researchLabLevel: Int?
    private var shipyardLevel: Int?
    
    // MARK: - Configure Player
    func configurePlayerDataWith(serverData: ServerData) async throws -> PlayerData {
        do {
            self.doc = try SwiftSoup.parse(serverData.landingPage)
            let planetName = try doc!.select("[name=ogame-planet-name]")
            let planetID = try doc!.select("[name=ogame-planet-id]")
            
            let planetNameContent = try planetName.get(0).attr("content")
            let planetIDContent = try planetID.get(0).attr("content")
            
            let playerName = try doc!.select("[name=ogame-player-name]").get(0).attr("content")
            let playerID = try doc!.select("[name=ogame-player-id]").get(0).attr("content")
            
            self.planet = planetNameContent
            self.planetID = Int(planetIDContent)
            self.playerName = playerName
            self.playerID = Int(playerID)
            
            self.rank = getRank()
            self.planetNames = getPlanetNames()
            self.planetIDs = getPlanetIDs()
            self.commander = getCommander()
            
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    let images = try await self.getAllPlanetImages()
                    self.planetImages = images
                }
                group.addTask {
                    let celestials = OGCelestials()
                    let allCelestials = try await celestials.getAllCelestialsWith(serverData: serverData)
                    self.celestials = allCelestials
                }
                group.addTask {
                    let facilities = OGFacilities()
                    let mainFacilitiesLevels = try await facilities.getMainFacilitiesLevels(indexPHP: serverData.indexPHP, planetID: Int(planetIDContent)!)
                    self.roboticsFactoryLevel = mainFacilitiesLevels[0]
                    self.naniteFactoryLevel = mainFacilitiesLevels[1]
                    self.researchLabLevel = mainFacilitiesLevels[2]
                    self.shipyardLevel = mainFacilitiesLevels[3]
                }
            }
            
            let playerData = PlayerData(doc: doc!,
                                        indexPHP: serverData.indexPHP,
                                        universe: serverData.universe,
                                        planet: planet!,
                                        planetID: Int(planetIDContent)!,
                                        playerName: playerName,
                                        playerID: Int(playerID)!,
                                        rank: rank!,
                                        planetNames: planetNames!,
                                        planetIDs: planetIDs!,
                                        commander: commander!,
                                        planetImages: planetImages!,
                                        celestials: celestials!,
                                        roboticsFactoryLevel: roboticsFactoryLevel!,
                                        naniteFactoryLevel: naniteFactoryLevel!,
                                        researchLabLevel: researchLabLevel!,
                                        shipyardLevel: shipyardLevel!)
            return playerData
            
        } catch {
            throw OGError(message: "Player configuration error", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - SUPPORT FUNCTIONS
    
    
    
    // MARK: - Get Rank
    func getRank() -> Int {
        do {
            let idBar = try doc!.select("[id=bar]").get(0)
            let li = try idBar.select("li").get(1)
            let text = try li.text()
            
            let pattern = "\\((.*?)\\)"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            var matches = results.map { nsString.substring(with: $0.range)}
            matches[0].removeFirst()
            matches[0].removeLast()
            let rank = matches[0]
            
            return Int(rank) ?? -1
            
        } catch {
            return -1
        }
    }
    
    // MARK: - Get Planet Names
    func getPlanetNames() -> [String] {
        do {
            var planetNames = [String]()
            let planets = try doc!.select("[class=planet-name]")
            for planet in planets {
                planetNames.append(try planet.text())
            }
            return planetNames
            
        } catch {
            return ["Error"]
        }
    }
    
    // MARK: - Get Planet IDs
    func getPlanetIDs() -> [Int] {
        do {
            var ids = [Int]()
            let planets = try doc!.select("[class*=smallplanet]")
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
    
    // MARK: - Get Commander
    func getCommander() -> Bool {
        // TODO: test on 3 days commander account
        if let commanders = try? doc!.select("[id=officers]").select("[class*=tooltipHTML  on]").select("[class*=commander]") {
            return !commanders.isEmpty() ? true : false
        } else {
            return false
        }
    }
    
    // MARK: - Get All Planets Images
    func getAllPlanetImages() async throws -> [UIImage] {
        do {
            var images: [UIImage] = []
            let planets = try doc!.select("[class*=smallplanet]")
            
            try await withThrowingTaskGroup(of: UIImage.self) { group in
                for planet in planets {
                    group.addTask {
                        let imageAttribute = try planet.select("[width=48]").first()!.attr("src")
                        let value = try await AF.request("\(imageAttribute)").serializingData().value
                        let image = UIImage(data: value)
                        return image!
                    }
                }
                for try await image in group {
                    images.append(image)
                }
            }
            return images
            
        } catch {
            throw OGError(message: "Error getting all planet images", detailed: error.localizedDescription)
        }
    }
}
