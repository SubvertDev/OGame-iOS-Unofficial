//
//  OverviewPresenter.swift
//  OGame
//
//  Created by Subvert on 3/17/22.
//

import Foundation

protocol IOverviewPresenter {
    init(view: IOverviewView)
    func loadResources(for: PlayerData)
    func getOverviewInfo(for: PlayerData)
}

final class OverviewPresenter: IOverviewPresenter {
    
    unowned let view: IOverviewView
    private let resourcesProvider = ResourcesProvider()
    private let overviewProvider = OverviewProvider()
    
    init(view: IOverviewView) {
        self.view = view
    }
    
    // MARK: - Public
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

    func getOverviewInfo(for player: PlayerData) {
        view.showInfoLoading(true)
        Task {
            do {
                let overviewInfo = try await overviewProvider.getOverviewWith(playerData: player)
                await MainActor.run {
                    view.showInfoLoading(false)
                    view.updateTableView(with: overviewInfo)
                }
            } catch {
                await MainActor.run {
                    view.showInfoLoading(false)
                    view.showAlert(error: error as! OGError)
                }
            }
        }
    }
}
