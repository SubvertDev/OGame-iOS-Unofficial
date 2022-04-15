//
//  BuildingPresenter.swift
//  OGame
//
//  Created by Subvert on 3/25/22.
//

import Foundation

protocol IBuildingPresenter {
    init(view: IBuildingView)
    func loadResources(for: PlayerData)
    func loadBuildings(for: PlayerData, with: BuildingType)
}

final class BuildingPresenter: IBuildingPresenter {
    
    unowned private var view: IBuildingView
    private let resourcesProvider = ResourcesProvider()
    private let queueProvider = QueueProvider()
    var buildings: [Building] = []
    var buildType: BuildingType?
    
    init(view: IBuildingView) {
        self.view = view
    }
    
    // MARK: Public
    func loadResources(for player: PlayerData) {
        view.showResourcesLoading(true)
        Task {
            do {
                let resources = try await resourcesProvider.getResourcesWith(playerData: player)
                await MainActor.run {
                    view.updateResourcesBar(with: resources)
                    view.showResourcesLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
    
    func loadBuildings(for player: PlayerData, with type: BuildingType) {
        self.buildType = type
        view.showBuildingsLoading(true)
        Task {
            do {
                switch type {
                case .supplies:
                    buildings = try await SuppliesProvider.getSuppliesWith(playerData: player)
                case .facilities:
                    buildings = try await FacilitiesProvider.getFacilitiesWith(playerData: player)
                case .research:
                    buildings = try await ResearchProvider.getResearchesWith(playerData: player)
                case .shipyard:
                    buildings = try await ShipyardProvider.getShipsWith(playerData: player)
                case .defenses:
                    buildings = try await DefenceProvider.getDefencesWith(playerData: player)
                }
                await MainActor.run {
                    view.updateBuildings(buildings)
                    view.showBuildingsLoading(false)
                }
                
                loadQueues(for: player)
                
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
    
    private func loadQueues(for player: PlayerData) {
        Task {
            do {
                switch buildType! {
                case .supplies:
                    buildings += try await FacilitiesProvider.getFacilitiesWith(playerData: player)
                case .facilities:
                    buildings += try await SuppliesProvider.getSuppliesWith(playerData: player)
                case .research:
                    break
                case .shipyard:
                    buildings += try await DefenceProvider.getDefencesWith(playerData: player)
                case .defenses:
                    buildings += try await ShipyardProvider.getShipsWith(playerData: player)
                }
                
                let queues = try await queueProvider.getQueue(player: player, buildings: buildings)
                
                switch buildType! {
                case .supplies, .facilities:
                    await updateThatQueue(with: queues[0])
                case .research:
                    await updateThatQueue(with: queues[1])
                case .shipyard, .defenses:
                    await updateThatQueue(with: queues[2])
                }
            } catch {
                throw OGError(message: "Error", detailed: "Can't load queues")
            }
        }
    }
    
    private func updateThatQueue(with buildings: [Building]) async {
        await MainActor.run {
            view.updateQueue(with: buildings)
        }
    }
}
