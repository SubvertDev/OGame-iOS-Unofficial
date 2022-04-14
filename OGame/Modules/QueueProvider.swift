//
//  QueueProvider.swift
//  OGame
//
//  Created by Subvert on 4/10/22.
//

import Foundation
import Alamofire
import SwiftSoup

typealias BuildingsQueue = [QueueItem]
typealias ResearchQueue = [QueueItem]
typealias ShipyardQueue = [QueueItem]

struct QueueItem {
    let id: Int
    let amount: Int
}

final class QueueProvider {

    func getQueue(player: PlayerData, buildings: [Building]) async throws -> [[Building]] {
        let link = "\(player.indexPHP)page=ingame&component=overview&cp=\(player.planetID)"
        let value = try await AF.request(link).serializingData().value

        let text = String(data: value, encoding: .ascii)!
        let page = try SwiftSoup.parse(text)
        let queues = getQueueData(document: page)
        let buildings = convertQueuesToBuildings(queues: queues, buildings: buildings)

        return buildings
    }

    private func getQueueData(document doc: Document) -> [[QueueItem]] {
        do {
            // MARK: - Buildings
            let buildingBox = try doc.select("[class*=productionboxbuilding]").get(0)
            let buildingCheck = try buildingBox.select("[class=idle]").isEmpty()
            var buildingFullQueue: [QueueItem] = []

            if buildingCheck {
                let activeBuilding = try buildingBox.select("[class=construction active]").get(0)
                let activeBuildingLevel = Int(try activeBuilding.select("[class=level]").get(0).text().replacingOccurrences(of: "Level ", with: "")) ?? 0
                let activeBuildingId = Int(try activeBuilding.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                buildingFullQueue.append(QueueItem(id: activeBuildingId, amount: activeBuildingLevel))

                let queueCheck = try buildingBox.select("[class=queue]").isEmpty()
                if !queueCheck {
                    let buildingQueue = try buildingBox.select("[class=queue]").get(0)
                    let buildingQueueItems = try buildingQueue.select("td")
                    for building in buildingQueueItems {
                        let amount = Int(try building.text()) ?? 0
                        let id = Int(try building.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                        buildingFullQueue.append(QueueItem(id: id, amount: amount))
                    }
                }
            }

            // MARK: - Research
            let researchBox = try doc.select("[class*=productionboxresearch]").get(0)
            let researchCheck = try researchBox.select("[class=idle]").isEmpty()
            var researchFullQueue: [QueueItem] = []

            if researchCheck {
                let activeResearch = try researchBox.select("[class=construction active]").get(0)
                let activeResearchLevel = Int(try activeResearch.select("[class=level]").get(0).text().replacingOccurrences(of: "Level ", with: "")) ?? 0
                let activeResearchId = Int(try activeResearch.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                researchFullQueue.append(QueueItem(id: activeResearchId, amount: activeResearchLevel))

                let queueCheck = try researchBox.select("[class=queue]").isEmpty()
                if !queueCheck {
                    let researchQueue = try researchBox.select("[class=queue]").get(0)
                    let researchQueueItems = try researchQueue.select("td")
                    for research in researchQueueItems {
                        let amount = Int(try research.text()) ?? 0
                        let id = Int(try research.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                        researchFullQueue.append(QueueItem(id: id, amount: amount))
                    }
                }
            }

            // MARK: - Shipyard
            let shipyardBox = try doc.select("[class*=productionboxshipyard]").get(0)
            let shipyardCheck = try shipyardBox.select("[class=idle]").isEmpty()
            var shipyardFullQueue: [QueueItem] = []

            if shipyardCheck {
                let activeShipyard = try shipyardBox.select("[class=construction active]").get(0)
                //let activeShipyardName = try activeShipyard.select("th").get(0).text()
                let activeShipyardAmount = Int(try activeShipyard.select("[class=shipSumCount]").get(0).text()) ?? 0
                let activeShipyardId = Int(try activeShipyard.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                shipyardFullQueue.append(QueueItem(id: activeShipyardId, amount: activeShipyardAmount))

                let queueCheck = try shipyardBox.select("[class=queue]").isEmpty()
                if !queueCheck {
                    let shipyardQueue = try shipyardBox.select("[class=queue]").get(0)
                    let shipyardQueueItems = try shipyardQueue.select("td")
                    for ship in shipyardQueueItems {
                        let amount = Int(try ship.text()) ?? 0
                        let id = Int(try ship.select("[class*=queuePic]").get(0).attr("alt").replacingOccurrences(of: "techId_", with: "")) ?? 0
                        shipyardFullQueue.append(QueueItem(id: id, amount: amount))
                    }
                }
            }
            //print(buildingFullQueue)
            //print(researchFullQueue)
            //print(shipyardFullQueue)
            return [buildingFullQueue, researchFullQueue, shipyardFullQueue]
        } catch {
            print("ERROR")
        }
        return [[], [], []]
    }
    
    private func convertQueuesToBuildings(queues: [[QueueItem]], buildings: [Building]) -> [[Building]] {
                
        var supplyBuildings: [Building] = []
        for supply in queues[0] {
            for building in buildings {
                if supply.id == building.buildingsID {
                    var building = building
                    building.levelOrAmount = supply.amount
                    supplyBuildings.append(building)
                }
            }
        }
        
        var researchBuildings: [Building] = []
        for research in queues[1] {
            for building in buildings {
                if research.id == building.buildingsID {
                    var building = building
                    building.levelOrAmount = research.amount
                    researchBuildings.append(building)
                }
            }
        }
        
        var shipyardBuildings: [Building] = []
        //print("queues2: \(queues[2])")
        for _ in buildings {
            //print("bbb: \(item.levelOrAmount)")
        }
        for shipyard in queues[2] {
            for building in buildings {
                if shipyard.id == building.buildingsID {
                    //print("YEAH")
                    var building = building
                    building.levelOrAmount = shipyard.amount
                    shipyardBuildings.append(building)
                }
            }
        }
        //print("shipz \(shipyardBuildings)")
        return [supplyBuildings, researchBuildings, shipyardBuildings]
    }
}
