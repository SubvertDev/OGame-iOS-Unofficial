//
//  OGCelestials.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGCelestials {
    
    // MARK: - Get All Celestials
    func getAllCelestialsWith(serverData: ServerData) async throws -> [Celestial] {
        do {
            var celestials: [Celestial] = []
            
            let link = "\(serverData.indexPHP)page=ingame&component=overview" // TODO: Fatal error while Logout on server list loading?
            let value = try await AF.request(link).serializingData().value
            
            let text = String(data: value, encoding: .ascii)!
            let page = try SwiftSoup.parse(text)
            
            guard !noScriptCheck(with: page)
            else { throw OGError(message: "Not logged in", detailed: "Celestials login check failed") }
            
            let planets = try page.select("[id=planetList]").get(0)
            let planetsInfo = try planets.select("[id*=planet-]")
            for planet in planetsInfo {
                let title = try planet.select("a").get(0).attr("title")
                let textArray = title.components(separatedBy: "><")
                
                // TODO: Not tested for moons
                var coordinatesString = textArray[0].components(separatedBy: " ")[1].replacingOccurrences(of: "</b", with: "")
                coordinatesString.removeFirst()
                coordinatesString.removeLast()
                var coordinates = coordinatesString.components(separatedBy: ":").compactMap { Int($0) }
                coordinates.append(1)
                
                var planetSizeString = textArray[1].components(separatedBy: " ")[0]
                planetSizeString.removeFirst(4)
                planetSizeString.removeLast(2)
                let planetSize = Int(planetSizeString.replacingOccurrences(of: ".", with: ""))!
                
                var planetFieldsString = textArray[1].components(separatedBy: " ")[1]
                planetFieldsString = planetFieldsString.components(separatedBy: ")")[0]
                planetFieldsString.removeFirst()
                let planetFieldUsed = Int(planetFieldsString.components(separatedBy: "/")[0])!
                let planetFieldTotal = Int(planetFieldsString.components(separatedBy: "/")[1])!
                
                var planetMinTemperatureString = textArray[1].components(separatedBy: " ")[1]
                planetMinTemperatureString = planetMinTemperatureString.components(separatedBy: "<br>")[1]
                let planetMinTemperature = Int(planetMinTemperatureString.components(separatedBy: "Â")[0])!
                let planetMaxTemperatureString = textArray[1].components(separatedBy: " ")[3]
                let planetMaxTemperature = Int(planetMaxTemperatureString.components(separatedBy: "Â")[0])!
                
                let celestial = Celestial(planetSize: planetSize,
                                          usedFields: planetFieldUsed,
                                          totalFields: planetFieldTotal,
                                          tempMin: planetMinTemperature,
                                          tempMax: planetMaxTemperature,
                                          coordinates: coordinates)
                celestials.append(celestial)
            }
            return celestials
            
        } catch {
            throw OGError(message: "Celestials parse error", detailed: error.localizedDescription)
        }
    }
}
