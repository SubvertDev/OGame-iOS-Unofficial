//
//  CheckFleetProvider.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

final class CheckFleetProvider {
    
    // MARK: - Get Fleet
    func getFleetWith(playerData: PlayerData) async throws -> [Fleets] {
        try await withThrowingTaskGroup(of: [Fleets].self) { group in
            var fleets = [Fleets]()
            
            group.addTask { return try await self.getHostileFleetWith(playerData) }
            group.addTask { return try await self.getFriendlyFleetWith(playerData) }
            
            for try await fleet in group {
                fleets.append(contentsOf: fleet)
            }
            
            return fleets
        }
    }
    
    
    // MARK: - Get Hostile Fleet
    private func getHostileFleetWith(_ playerData: PlayerData) async throws -> [Fleets] {
        do {
            let link = "\(playerData.indexPHP)page=componentOnly&component=eventList"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let eventFleetParse = try page.select("[class=eventFleet]").select("[class*=hostile]")
            let eventFleet = Elements()
            for event in eventFleetParse {
                if let fleet = event.parent()?.parent() {
                    eventFleet.add(fleet)
                }
            }
            
            var fleetIDs = [Int]()
            var arrivalTimes = [Int]()
            var playerNames = [String]()
            var playerIDs = [Int]()
            var playerPlanet = [String]()
            var enemyPlanet = [String]()
            
            for event in eventFleet {
                fleetIDs.append(Int(try event.attr("id").replacingOccurrences(of: "eventRow-", with: ""))!)
                arrivalTimes.append(Int(try event.attr("data-arrival-time"))!)
                playerNames.append(try event.select("[class*=sendMail ]").attr("title"))
                playerIDs.append(Int(try event.select("[class*=sendMail ]").attr("data-playerid"))!)
                playerPlanet.append(try event.select("[class=destFleet]").text())
                enemyPlanet.append(try event.select("[class=originFleet]").text())
            }
            
            let destinations = getFleetCoordinates(details: eventFleet, type: "destCoords")
            let origins = getFleetCoordinates(details: eventFleet, type: "coordsOrigin")
            
            var fleets: [Fleets] = []
            guard !fleetIDs.isEmpty
            else { return fleets }
            
            for i in 0...fleetIDs.count - 1 {
                let fleet = Fleets(id: fleetIDs[i],
                                   mission: "Attacked",
                                   diplomacy: "hostile",
                                   playerName: playerData.playerName,
                                   playerID: playerData.playerID,
                                   playerPlanet: playerPlanet[i],
                                   playerPlanetImage: nil,
                                   enemyName: playerNames[i],
                                   enemyID: playerIDs[i],
                                   enemyPlanet: enemyPlanet[i],
                                   enemyPlanetImage: nil,
                                   returns: false,
                                   arrivalTime: arrivalTimes[i],
                                   endTime: nil,
                                   origin: origins[i],
                                   destination: destinations[i])
                fleets.append(fleet)
            }
            return fleets
            
        } catch {
            throw OGError(message: "Get hostile fleet error", detailed: error.localizedDescription)
        }
    }


    // MARK: - Get Friendly Fleet
    private func getFriendlyFleetWith(_ playerData: PlayerData) async throws -> [Fleets] {
        do {
            let link = "\(playerData.indexPHP)page=ingame&component=movement"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            let fleetDetails = try page.select("[class*=fleetDetails]")
            
            var fleetIDs = [Int]()
            var missionTypes = [String]()
            var missionDiplomacy = [String]()
            var arrivalTimes = [Int]()
            var endTimes = [Int]()
            var returnFlights = [Bool]()
            var playerPlanet = [String]()
            var enemyPlanet = [String]()
            
            var playerPlanetImageUrl = [String]()
            var enemyPlanetImageUrl = [String]()
            
            var playerPlanetImages = [UIImage]()
            var enemyPlanetImages = [UIImage]()
            
            for event in fleetDetails {
                fleetIDs.append(Int(try event.attr("id").replacingOccurrences(of: "fleet", with: ""))!)
                missionDiplomacy.append(try event.select("span[class*=mission]").attr("class").components(separatedBy: " ")[1])
                missionTypes.append(try event.select("span[class*=mission]").get(0).text())
                arrivalTimes.append(Int(try event.attr("data-arrival-time"))!)
                endTimes.append(Int(try event.select("[data-end-time]").attr("data-end-time"))!)
                playerPlanet.append(try event.select("[class=originPlanet]").text())
                enemyPlanet.append(try event.select("[class=destinationData]").text().components(separatedBy: " ")[0])
                
                if try event.attr("data-return-flight") == "1" {
                    returnFlights.append(true)
                } else {
                    returnFlights.append(false)
                }
                
                playerPlanetImageUrl.append(try event.select("[class=origin fixed]").select("[class*=tooltipHTML]").attr("src"))
                enemyPlanetImageUrl.append(try event.select("[class=destination fixed]").select("[class*=tooltipHTML]").attr("src"))
            }
            
            let destinations = self.getFleetCoordinates(details: fleetDetails, type: "destinationCoords")
            let origins = self.getFleetCoordinates(details: fleetDetails, type: "originCoords")
            
            var fleets = [Fleets]()
            
            guard !fleetIDs.isEmpty
            else { return fleets }
            
            let playerImages = try await getImagesFromUrl(playerPlanetImageUrl)
            playerPlanetImages.append(contentsOf: playerImages)
            
            let enemyImages = try await getImagesFromUrl(enemyPlanetImageUrl)
            enemyPlanetImages.append(contentsOf: enemyImages)
            
            for i in 0...fleetIDs.count - 1 {
                fleets.append(Fleets(id: fleetIDs[i],
                                     mission: missionTypes[i],
                                     diplomacy: missionDiplomacy[i],
                                     playerName: playerData.playerName,
                                     playerID: playerData.playerID,
                                     playerPlanet: playerPlanet[i],
                                     playerPlanetImage: playerPlanetImages[i],
                                     enemyName: nil,
                                     enemyID: nil,
                                     enemyPlanet: enemyPlanet[i],
                                     enemyPlanetImage: enemyPlanetImages[i],
                                     returns: returnFlights[i],
                                     arrivalTime: arrivalTimes[i],
                                     endTime: endTimes[i],
                                     origin: origins[i],
                                     destination: destinations[i]))
            }
            return fleets
            
        } catch {
            throw OGError(message: "Get friendly fleet error", detailed: error.localizedDescription)
        }
    }

    
    // MARK: - Get Fleet Coordinates
    private func getFleetCoordinates(details: Elements, type: String) -> [[Int]] {
        // TODO: Test with moon/expedition
        var coordinates = [[Int]]()

        for detail in details {
            var coordinateString = try! detail.select("[class*=\(type)]").text().trimmingCharacters(in: .whitespacesAndNewlines)
            coordinateString.removeFirst()
            coordinateString.removeLast()
            var coordinate = coordinateString.components(separatedBy: ":").compactMap { Int($0) }
            
            var destination = String()
            if type == "destinationCoords" {
                let figure = try! detail.select("figure")
                if figure.count == 1 {
                    destination = "expedition"
                } else {
                    destination = try! figure.get(1).select("[class*=planetIcon]").attr("class").replacingOccurrences(of: "planetIcon ", with: "")
                }
            } else {
                let figure = try! detail.select("figure").get(0)
                destination = try! figure.select("[class*=planetIcon]").attr("class").replacingOccurrences(of: "planetIcon ", with: "")
            }
            
            switch destination {
            case "expedition":
                coordinate.append(0) // expedition
            case "moon":
                coordinate.append(3) // moon
            case "tf":
                coordinate.append(2) // debris
            default:
                coordinate.append(1) // planet
            }
            
            coordinates.append(coordinate)
        }
        
        return coordinates
    }
    
    // MARK: - Get Images From URL
    private func getImagesFromUrl(_ urls: [String]) async throws -> [UIImage] {
        do {
            var images: [UIImage] = []
            try await withThrowingTaskGroup(of: UIImage.self) { group in
                for url in urls {
                    group.addTask {
                        let value = try await AF.request(url).serializingData().value
                        let image = UIImage(data: value)
                        return image! // TODO: better way?
                    }
                }
                for try await imageResult in group {
                    images.append(imageResult)
                }
            }
            return images
            
        } catch {
            throw OGError(message: "Error getting planet images from url", detailed: error.localizedDescription)
        }
    }
}
