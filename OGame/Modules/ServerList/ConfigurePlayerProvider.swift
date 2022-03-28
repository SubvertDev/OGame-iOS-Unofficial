//
//  ConfigurePlayerProvider.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

final class ConfigurePlayerProvider {
          
    // MARK: - Properties
    private var doc: Document?
    
    private var planet: String?
    private var planetID: Int?
    private var playerName: String?
    private var playerID: Int?
    
    private var rank: Int?
    private var planetNames: [String]?
    private var planetIDs: [Int]?
    private var moonNames: [String]?
    private var moonIDs: [Int]?
    private var commander: Bool?
    
    private var planetImages: [UIImage]?
    private var moonImages: [UIImage?]?
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
            self.moonNames = getMoonNames()
            self.moonIDs = getMoonIDs()
            self.commander = getCommander()
            
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    let images = try await self.getAllPlanetImages()
                    self.planetImages = images
                }
                group.addTask {
                    let сelestials = try await OGCelestials.getAllCelestialsWith(serverData: serverData)
                    self.celestials = сelestials
                }
                group.addTask {
                    let mainFacilitiesLevels = try await OGFacilities.getMainFacilitiesLevels(indexPHP: serverData.indexPHP, planetID: Int(planetIDContent)!)
                    self.roboticsFactoryLevel = mainFacilitiesLevels[0]
                    self.naniteFactoryLevel = mainFacilitiesLevels[1]
                    self.researchLabLevel = mainFacilitiesLevels[2]
                    self.shipyardLevel = mainFacilitiesLevels[3]
                }
                group.addTask {
                    self.moonImages = try await self.getAllMoonsImages()
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
                                        moonNames: moonNames!,
                                        moonIDs: moonIDs!,
                                        commander: commander!,
                                        planetImages: planetImages!,
                                        moonImages: moonImages!,
                                        celestials: celestials!,
                                        roboticsFactoryLevel: [roboticsFactoryLevel!],
                                        naniteFactoryLevel: [naniteFactoryLevel!],
                                        researchLabLevel: [researchLabLevel!],
                                        shipyardLevel: [shipyardLevel!])
            return playerData
            
        } catch {
            throw OGError(message: "Player configuration error", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Get Rank
    private func getRank() -> Int {
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
    private func getPlanetNames() -> [String] {
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
    private func getPlanetIDs() -> [Int] {
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
    
    // MARK: - Get Moon Names
    private func getMoonNames() -> [String] {
        do {
            var moonNames = [String]()
            let moons = try doc!.select("[class*=smallplanet")
            for moon in moons {
                let moonlink = try moon.select("[class*=moonlink]")
                if moonlink.count != 0 {
                    let moonName = try moonlink.get(0).select("[class=icon-moon]").get(0).attr("alt")
                    moonNames.append(moonName)
                } else {
                    moonNames.append("")
                }
            }
            return moonNames
            
        } catch {
            return ["Error"]
        }
    }
    
    // MARK: - Get Moon IDs
    private func getMoonIDs() -> [Int] {
        do {
            var ids = [Int]()
            let moons = try doc!.select("[class*=smallplanet")
            for moon in moons {
                let moonlink = try moon.select("[class*=moonlink]")
                if moonlink.count != 0 {
                    let idAttribute = try moonlink.get(0).attr("href")
                    let moonID = Int(idAttribute.components(separatedBy: "&cp=")[1])
                    ids.append(moonID!)
                } else {
                    ids.append(0)
                }
            }
            return ids

        } catch {
            return [-1]
        }
    }
    
    // MARK: - Get Commander
    private func getCommander() -> Bool {
        // TODO: test on 3 days commander account
        if let commanders = try? doc!.select("[id=officers]").select("[class*=tooltipHTML  on]").select("[class*=commander]") {
            return !commanders.isEmpty() ? true : false
        } else {
            return false
        }
    }
    
    // MARK: - Get All Planets Images
    private func getAllPlanetImages() async throws -> [UIImage] {
        do {
            var images: [UIImage] = Array(repeating: UIImage(), count: planetIDs!.count)
            let planets = try doc!.select("[class*=smallplanet]")
            
            try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
                for (index, planet) in planets.enumerated() {
                    group.addTask {
                        let imageAttribute = try planet.select("[width=48]").first()!.attr("src")
                        let value = try await AF.request("\(imageAttribute)").serializingData().value
                        let image = UIImage(data: value)
                        return (index, image!)
                    }
                }
                for try await result in group {
                    images[result.0] = result.1
                }
            }
            return images
            
        } catch {
            throw OGError(message: "Error getting all planet images", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Get All Moons Images
    private func getAllMoonsImages() async throws -> [UIImage?] {
        do {
            var images: [UIImage?] = Array(repeating: nil, count: planetIDs!.count)
            let moons = try doc!.select("[class*=smallplanet]")
            
            try await withThrowingTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, moon) in moons.enumerated() {
                    group.addTask {
                        let moonlink = try moon.select("[class*=moonlink]")
                        if moonlink.count != 0 {
                            let imageAttribute = try moonlink.get(0).select("[width=16]").first()!.attr("src")
                            let value = try await AF.request("\(imageAttribute)").serializingData().value
                            let image = UIImage(data: value)
                            return (index, image!)
                        } else {
                            return (index, nil)
                        }
                    }
                }
                for try await result in group {
                    images[result.0] = result.1
                }
            }
            return images
            
        } catch {
            throw OGError(message: "Error getting all planet images", detailed: error.localizedDescription)
        }
    }
}
