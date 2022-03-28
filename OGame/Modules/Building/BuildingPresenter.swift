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
    var buildings: [Building] = []
    
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
                await MainActor.run {
                    view.showResourcesLoading(false)
                    view.showAlert(error: error as! OGError)
                }
            }
        }
    }
    
    func loadBuildings(for player: PlayerData, with type: BuildingType) {
        view.showBuildingsLoading(true)
        Task {
            do {
                switch type {
                case .supplies:
                    buildings = try await OGSupplies.getSuppliesWith(playerData: player)
                case .facilities:
                    buildings = try await OGFacilities.getFacilitiesWith(playerData: player)
                case .research:
                    buildings = try await OGResearch.getResearchesWith(playerData: player)
                case .shipyard:
                    buildings = try await OGShipyard.getShipsWith(playerData: player)
                case .defenses:
                    buildings = try await OGDefence.getDefencesWith(playerData: player)
                }
                await MainActor.run {
                    view.updateBuildings(buildings)
                    view.showBuildingsLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
}
