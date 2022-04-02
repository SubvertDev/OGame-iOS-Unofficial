//
//  SendFleetPresenter.swift
//  OGame
//
//  Created by Subvert on 3/31/22.
//

import Foundation

protocol ISendFleetPresenter {
    func loadResources(for: PlayerData)
    func getInitialTarget(for: PlayerData, at: Coordinates, with: [Building])
}

final class SendFleetPresenter: ISendFleetPresenter {
    
    unowned let view: ISendFleetView
    private let resourcesProvider = ResourcesProvider()
    private let sendFleetProvider = SendFleetProvider()
        
    private var orders: [Int: Bool] = [:] // todo ? instead
    
    init(view: ISendFleetView) {
        self.view = view
    }
    
    // MARK: Public
    func getInitialTarget(for player: PlayerData, at coordinates: Coordinates, with ships: [Building]) {
        view.showFleetSendLoading(true)
        Task {
            do {
                let targetData = try await sendFleetProvider.checkTarget(player: player, whereTo: coordinates, ships: ships)
                for order in targetData.orders! {
                    let orderKeyInt = Int(order.key)! - 1
                    if orderKeyInt != 15 {
                        orders[orderKeyInt] = order.value
                    } else {
                        orders[9] = order.value
                    }
                }
                await MainActor.run {
                    view.updateFleetSend(with: orders)
                    view.showFleetSendLoading(false)
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
