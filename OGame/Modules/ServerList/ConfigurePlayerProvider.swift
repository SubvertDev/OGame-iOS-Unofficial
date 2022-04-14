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
    private var universeInfo: UniverseInfo?
    
    private var planet: String?
    private var planetID: Int?
    private var playerName: String?
    private var playerID: Int?
    
    private var rank: Int?
    private var planetNames: [String]?
    private var planetIDs: [Int]?
    private var moonNames: [String]?
    private var moonIDs: [Int]?
    private var characterClass: CharacterClass?
    private var officers: Officers?
    
    private var planetImages: [UIImage]?
    private var moonImages: [UIImage?]?
    private var celestials: [Celestial]?

    private var factoryLevels: [FactoryLevels]?
    
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
            
            self.universeInfo = getUniverseInfo()
            self.rank = getRank()
            self.planetNames = getPlanetNames()
            self.planetIDs = getPlanetIDs()
            self.moonNames = getMoonNames()
            self.moonIDs = getMoonIDs()
            self.characterClass = getCharacterClass()
            self.officers = getOfficers()
            
            await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask {
                    let images = try await self.getAllPlanetImages()
                    self.planetImages = images
                }
                group.addTask {
                    let сelestials = try await CelestialsProvider.getAllCelestialsWith(serverData: serverData)
                    self.celestials = сelestials
                }
                group.addTask {
                    // TODO: FIX working but serial
                    var allLevels: [FactoryLevels] = []
                    for planetID in self.planetIDs! {
                        let levels = try await FacilitiesProvider.getMainFacilitiesLevels(indexPHP: serverData.indexPHP, planetID: planetID)
                        let result = FactoryLevels(roboticsFactoryLevel: levels[0],
                                                   naniteFactoryLevel: levels[1],
                                                   researchLabLevel: levels[2],
                                                   shipyardLevel: levels[3])
                        allLevels.append(result)
                    }
                    self.factoryLevels = allLevels
                }
                group.addTask {
                    self.moonImages = try await self.getAllMoonsImages()
                }
            }
            print(factoryLevels!)
            
            // NOT WORKING, RESULT DATA IS MIXED UP
            //            let levels = try await withThrowingTaskGroup(of: [Int].self, returning: [FactoryLevels].self) { group in
            //                for planetID in planetIDs! {
            //                    print(planetID)
            //                    group.addTask {
            //                        return try await FacilitiesProvider.getMainFacilitiesLevels(indexPHP: serverData.indexPHP, planetID: planetID)
            //                    }
            //                }
            //
            //                var factoryLevels: [FactoryLevels] = []
            //                for try await levels in group {
            //                    let levels = FactoryLevels(roboticsFactoryLevel: levels[0],
            //                                               naniteFactoryLevel: levels[1],
            //                                               researchLabLevel: levels[2],
            //                                               shipyardLevel: levels[3])
            //                    factoryLevels.append(levels)
            //                }
            //                return factoryLevels
            //            }
            //            print("LEVELS DATA: \(levels)")
            
            let playerData = PlayerData(doc: doc!,
                                        indexPHP: serverData.indexPHP,
                                        universe: serverData.universe,
                                        universeInfo: universeInfo!,
                                        planet: planet!,
                                        planetID: Int(planetIDContent)!,
                                        playerName: playerName,
                                        playerID: Int(playerID)!,
                                        rank: rank!,
                                        planetNames: planetNames!,
                                        planetIDs: planetIDs!,
                                        moonNames: moonNames!,
                                        moonIDs: moonIDs!,
                                        characterClass: characterClass!,
                                        officers: officers!,
                                        planetImages: planetImages!,
                                        moonImages: moonImages!,
                                        celestials: celestials!,
                                        factoryLevels: factoryLevels!)
            return playerData
            
        } catch {
            throw OGError(message: "Player configuration error", detailed: error.localizedDescription)
        }
    }
    
    // MARK: - Get Universe Info
    private func getUniverseInfo() -> UniverseInfo {
        do {
            let version = try doc!.select("[name=ogame-version]").get(0).attr("content")
            let universe = Int(try doc!.select("[name=ogame-universe-speed]").get(0).attr("content")) ?? 0
            let fleetSpeedPeaceful = Int(try doc!.select("[name=ogame-universe-speed-fleet-peaceful]").get(0).attr("content")) ?? 0
            let fleetSpeedWar = Int(try doc!.select("[name=ogame-universe-speed-fleet-war]").get(0).attr("content")) ?? 0
            let fleetSpeedHolding = Int(try doc!.select("[name=ogame-universe-speed-fleet-holding]").get(0).attr("content")) ?? 0
            let speed = Speed(universe: universe, peaceSpeed: fleetSpeedPeaceful,
                              warSpeed: fleetSpeedWar,
                              holdingSpeed: fleetSpeedHolding)
            
            let galaxyString = Int(try doc!.select("[name=ogame-donut-galaxy]").get(0).attr("content")) ?? 0
            let galaxy = galaxyString == 1 ? true : false
            let systemString = Int(try doc!.select("[name=ogame-donut-system]").get(0).attr("content")) ?? 0
            let system = systemString == 1 ? true : false
            let donut = Donut(galaxy: galaxy, system: system)
            
            return UniverseInfo(version: version, speed: speed, donut: donut)
            
        } catch {
            return UniverseInfo(version: "-1",
                                speed: Speed(universe: 0, peaceSpeed: 0, warSpeed: 0, holdingSpeed: 0),
                                donut: Donut(galaxy: false, system: false))
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
    
    // MARK: - Get CharacterClass
    private func getCharacterClass() -> CharacterClass {
        do {
            let characterClass = try doc!.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last!
            switch characterClass {
            case "miner":
                return .collector
            case "admiral": // todo test string
                return .admiral
            case "discoverer": // todo test string
                return .discoverer
            default: // "none"
                return .noClass
            }
        } catch {
            return .noClass
        }
    }
    
    // MARK: - Get Officers
    private func getOfficers() -> Officers {
        do {
            let officers = try doc!.select("[id=officers]").select("[class*=tooltipHTML  on]")
            let commander = try !officers.select("[class*=commander]").isEmpty()
            let admiral = try !officers.select("[class*=admiral]").isEmpty()
            let engineer = try !officers.select("[class*=engineer]").isEmpty()
            let geologist = try !officers.select("[class*=geologist]").isEmpty()
            let technocrat = try !officers.select("[class*=technocrat]").isEmpty()
            return Officers(commander: commander,
                            admiral: admiral,
                            engineer: engineer,
                            geologist: geologist,
                            technocrat: technocrat)
        } catch {
            return Officers(commander: false, admiral: false, engineer: false, geologist: false, technocrat: false)
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
