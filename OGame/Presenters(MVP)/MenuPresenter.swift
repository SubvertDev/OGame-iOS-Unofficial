//
//  MenuPresenter.swift
//  OGame
//
//  Created by Subvert on 3/27/22.
//

import Foundation

protocol IMenuPresenter {
    func viewDidLoad(with: PlayerData)
    func previousPlanetButtonTapped(for: PlayerData)
    func nextPlanetButtonTapped(for: PlayerData)
    func planetButtonTapped(for: PlayerData)
    func moonButtonTapped(for: PlayerData)
    func loadResources(for: PlayerData)
}

final class MenuPresenter: IMenuPresenter {
    
    unowned let view: IMenuView
    let resourcesProvider = ResourcesProvider()
    var player: PlayerData
    
    init(view: IMenuView, player: PlayerData) {
        self.view = view
        self.player = player
    }
    
    // MARK: Public
    func viewDidLoad(with player: PlayerData) {
        loadResources(for: player)
    }
    
    func previousPlanetButtonTapped(for player: PlayerData) {
        var player = player
        var index = 0
        if let planetIndex = player.planetIDs.firstIndex(of: player.planetID) {
            index = planetIndex
        } else if let moonIndex = player.moonIDs.firstIndex(of: player.planetID) {
            index = moonIndex
        } else {
            return
        }
        
        if index - 1 == -1 {
            player.currentPlanetIndex = player.planetNames.count - 1
            player.planet = player.planetNames.last!
            player.planetID = player.planetIDs.last!
        } else {
            player.currentPlanetIndex -= 1
            player.planet = player.planetNames[index - 1]
            player.planetID = player.planetIDs[index - 1]
        }

        view.showPlanetLoading(true)
        view.planetIsChanged(for: player)
    }
    
    func nextPlanetButtonTapped(for player: PlayerData) {
        var player = player
        var index = 0
        if let planetIndex = player.planetIDs.firstIndex(of: player.planetID) {
            index = planetIndex
        } else if let moonIndex = player.moonIDs.firstIndex(of: player.planetID) {
            index = moonIndex
        } else {
            return
        }
        
        if index + 1 == player.planetNames.count {
            player.currentPlanetIndex = 0
            player.planet = player.planetNames[0]
            player.planetID = player.planetIDs[0]
        } else {
            player.currentPlanetIndex += 1
            player.planet = player.planetNames[index + 1]
            player.planetID = player.planetIDs[index + 1]
        }

        view.showPlanetLoading(true)
        view.planetIsChanged(for: player)
    }
    
    func planetButtonTapped(for player: PlayerData) {
        var player = player
        if player.moonIDs.contains(player.planetID) {
            player.planet = player.planetNames[player.currentPlanetIndex]
            player.planetID = player.planetIDs[player.currentPlanetIndex]
            
            view.showPlanetLoading(true)
            view.planetIsChanged(for: player)
        }
    }
    
    func moonButtonTapped(for player: PlayerData) {
        var player = player
        if player.planetIDs.contains(player.planetID) {
            player.planet = player.moonNames[player.currentPlanetIndex]
            player.planetID = player.moonIDs[player.currentPlanetIndex]
            
            view.showPlanetLoading(true)
            view.planetIsChanged(for: player)
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
                    view.showPlanetLoading(false)
                }
            } catch {
                await MainActor.run {
                    view.showResourcesLoading(false)
                    view.showPlanetLoading(false)
                    //view.showAlert(error: error as! OGError)
                }
            }
        }
    }
    
    // MARK: Private
}
