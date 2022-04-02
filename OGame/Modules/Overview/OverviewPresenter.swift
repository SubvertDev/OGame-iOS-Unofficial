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
        view.showResourcesBarLoading(true)
        Task {
            do {
                let resources = try await resourcesProvider.getResourcesWith(playerData: player)
                await MainActor.run {
                    view.updateResourcesBar(with: resources)
                    view.showResourcesBarLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }

    func getOverviewInfo(for player: PlayerData) {
        view.showOverviewLoading(true)
        Task {
            do {
                let overviewInfo = try await overviewProvider.getOverviewWith(playerData: player)
                await MainActor.run {
                    view.showOverviewLoading(false)
                    view.updateOverview(with: overviewInfo)
                }
            } catch {
                await MainActor.run {
                    view.showOverviewLoading(false)
                    view.showAlert(error: error as! OGError)
                }
            }
        }
    }
}
