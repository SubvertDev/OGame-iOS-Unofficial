//
//  MovementPresenter.swift
//  OGame
//
//  Created by Subvert on 4/2/22.
//

import Foundation

protocol IMovementPresenter {
    func loadResources(for: PlayerData)
    func loadMovement(for: PlayerData)
}

final class MovementPresenter: IMovementPresenter {
    
    unowned let view: IMovementView
    private let resourcesProvider = ResourcesProvider()
    private let checkFleetProvider = CheckFleetProvider()
    
    init(view: IMovementView) {
        self.view = view
    }
    
    // MARK: Public
    func loadMovement(for player: PlayerData) {
        view.showMovementLoading(true)
        Task {
            do {
                let fleets = try await checkFleetProvider.getFleetWith(playerData: player)
                await MainActor.run {
                    view.updateMovementTableView(with: fleets)
                    view.showMovementLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
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
