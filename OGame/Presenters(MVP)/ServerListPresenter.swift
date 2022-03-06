//
//  ServerListPresenter.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

protocol ServerListPresenterDelegate {
    init(view: ServerListViewDelegate)
    @MainActor func enterServer(_ server: MyServer)
}

final class ServerListPresenter: ServerListPresenterDelegate {
    unowned let view: ServerListViewDelegate
    private let serverListProvider = ServerListProvider()
    private let configurePlayerProvider = ConfigurePlayerProvider()
    private let resourcesProvider = ResourcesProvider()
    
    required init(view: ServerListViewDelegate) {
        self.view = view
    }
    
    func enterServer(_ server: MyServer) {
        view.showLoading(true)
        Task {
            do {
                let serverData = try await serverListProvider.loginIntoServerWith(serverInfo: server)
                let playerData = try await configurePlayerProvider.configurePlayerDataWith(serverData: serverData)
                let resourcesData = try await resourcesProvider.getResourcesWith(playerData: playerData)
                view.performLogin(player: playerData, resources: resourcesData)
            } catch {
                view.showAlert(error: error)
            }
            view.showLoading(false)
        }
    }
}
