//
//  ServerListPresenter.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

protocol ServerListPresenterDelegate {
    init(view: ServerListViewDelegate)
    func enterServer(_ server: MyServer)
}

final class ServerListPresenter: ServerListPresenterDelegate {
    
    unowned let view: ServerListViewDelegate
    private let serverListProvider = ServerListProvider()
    private let configurePlayerProvider = ConfigurePlayerProvider()
    private let resourcesProvider = ResourcesProvider()
    
    required init(view: ServerListViewDelegate) {
        self.view = view
    }
    
    // MARK: Public
    func enterServer(_ server: MyServer) {
        view.showLoading(true)
        Task {
            do {
                let serverData = try await serverListProvider.loginIntoServerWith(serverInfo: server)
                let playerData = try await configurePlayerProvider.configurePlayerDataWith(serverData: serverData)
                let resourcesData = try await resourcesProvider.getResourcesWith(playerData: playerData)
                await MainActor.run { view.performLogin(player: playerData, resources: resourcesData) }
                // todo fix logout while entering server
                // Attempted to read an unowned reference but the object was already deallocated
            } catch {
                await MainActor.run { view.showAlert(error: error) }
            }
            await MainActor.run { view.showLoading(false) }
        }
    }
}
