//
//  OverviewPresenter.swift
//  OGame
//
//  Created by Subvert on 3/17/22.
//

import Foundation

protocol OverviewPresenterDelegate {
    init(view: OverviewViewDelegate)
    func getOverviewInfo(for: PlayerData)
}

final class OverviewPresenter: OverviewPresenterDelegate {
    
    unowned let view: OverviewViewDelegate
    private let overviewProvider = OverviewProvider()
    
    init(view: OverviewViewDelegate) {
        self.view = view
    }
    
    // MARK: - Get Overview Info
    func getOverviewInfo(for player: PlayerData) {
        view.showLoading(true)
        Task {
            do {
                let overviewInfo = try await overviewProvider.getOverviewWith(playerData: player)
                await MainActor.run {
                    view.showLoading(false)
                    view.updateTableView(with: overviewInfo)
                }
            } catch {
                await MainActor.run {
                    view.showLoading(false)
                    view.showAlert(error: error as! OGError)
                }
            }
        }
    }
}
