//
//  FleetPresenter.swift
//  OGame
//
//  Created by Subvert on 3/29/22.
//

import Foundation

protocol IFleetPresenter {
    func loadFleet(for: PlayerData)
    func getTargetData(for: PlayerData)
    func nextButtonTapped(with: [Building], amount: [Int])
    func resetButtonTapped()
    func loadResources(for: PlayerData)
}

final class FleetPresenter: IFleetPresenter {
    
    unowned let view: IFleetView
    private let resourcesProvider = ResourcesProvider()
    private let sendFleetProvider = SendFleetProvider()
    
    init(view: IFleetView) {
        self.view = view
    }
    
    // MARK: Public
    func loadFleet(for player: PlayerData) {
        view.showTableViewLoading(true)
        Task {
            do {
                let ships = try await ShipyardProvider.getShipsWith(playerData: player)
                await MainActor.run {
                    var ships = ships
                    ships.removeLast(2)
                    view.showTableViewLoading(false)
                    view.updateTableView(with: ships)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
    
    func getTargetData(for player: PlayerData) {
        Task {
            do {
                let coordinates = player.celestials[player.currentPlanetIndex].coordinates
                let targetCoordinates = Coordinates(galaxy: coordinates[0],
                                                    system: coordinates[1],
                                                    position: coordinates[2])
                let targetData = try await sendFleetProvider.checkTarget(player: player, whereTo: targetCoordinates)
                await MainActor.run { view.setTarget(with: targetData) }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
    
    func nextButtonTapped(with ships: [Building], amount amountOfShips: [Int]) {
        var shipsToSend = ships
        for (index, _) in ships.enumerated() {
            shipsToSend[index].levelOrAmount = amountOfShips[index]
        }
        
        for item in amountOfShips where item != 0 {
            view.openSendFleetVC(with: shipsToSend)
            break
        }
    }
    
    func resetButtonTapped() {
        view.resetFleet()
    }
    
    func loadResources(for player: PlayerData) {
        view.showResourcesLoading(true)
        Task {
            do {
                let resources = try await resourcesProvider.getResourcesWith(playerData: player)
                await MainActor.run {
                    view.updateResources(with: resources)
                    view.showResourcesLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
}
