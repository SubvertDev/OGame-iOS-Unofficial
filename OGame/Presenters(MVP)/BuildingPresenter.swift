//
//  BuildingPresenter.swift
//  OGame
//
//  Created by Subvert on 3/25/22.
//

import Foundation

protocol IBuildingPresenter {
    func loadBuildings(for: PlayerData, with: BuildingType)
}

final class BuildingPresenter: IBuildingPresenter {
    
    unowned var view: BuildingViewDelegate
    var buildings: [Building] = []
    
    init(view: BuildingViewDelegate) {
        self.view = view
    }
    
    // MARK: Public
    func loadBuildings(for player: PlayerData, with type: BuildingType) {
        Task {
            do {
                switch type {
                case .supply:
                    buildings = try await OGSupplies.getSuppliesWith(playerData: player)
                case .facility:
                    buildings = try await OGFacilities.getFacilitiesWith(playerData: player)
                case .research:
                    buildings = try await OGResearch.getResearchesWith(playerData: player)
                case .shipyard:
                    buildings = try await OGShipyard.getShipsWith(playerData: player)
                case .defence:
                    buildings = try await OGDefence.getDefencesWith(playerData: player)
                }
                await MainActor.run { view.showBuildings(buildings) }
            } catch {
                await MainActor.run { view.showError(error as! OGError) }
            }
        }
    }
}
