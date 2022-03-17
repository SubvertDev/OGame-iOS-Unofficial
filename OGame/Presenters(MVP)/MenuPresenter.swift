//
//  MenuPresenter.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import Foundation
import UIKit

protocol MenuPresenterDelegate {
    init(view: MenuViewDelegate)
    func setPreviousPlanet(for: PlayerData?)
    func planetButtonPressed(for: PlayerData?)
    func moonButtonPressed(for: PlayerData?)
}

final class MenuPresenter: MenuPresenterDelegate {
    unowned let view: MenuViewDelegate
    let resourcesProvider = ResourcesProvider()
    
    init(view: MenuViewDelegate) {
        self.view = view
    }
    
    // MARK: - Set Previous Planet
    func setPreviousPlanet(for player: PlayerData?) {
        guard var player = player else { return }
        
        view.showLoading(true)
        
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
        
        view.planetIsChanged(for: player)
        view.showLoading(false)
    }
    
    // MARK: - Set Next Planet
    func setNextPlanet(for player: PlayerData?) {
        guard var player = player else { return }
        view.showLoading(true)
        
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
        
        view.planetIsChanged(for: player)
        view.showLoading(false)
    }
    
    // MARK: - Planet Button Pressed
    func planetButtonPressed(for player: PlayerData?) {
        guard var player = player else { return }
        view.showLoading(true)
        
        if player.moonIDs.contains(player.planetID) {
            player.planet = player.planetNames[player.currentPlanetIndex]
            player.planetID = player.planetIDs[player.currentPlanetIndex]
            
            view.planetIsChanged(for: player)
        }
        view.showLoading(false)
    }
    
    // MARK: - Moon Button Pressed
    func moonButtonPressed(for player: PlayerData?) {
        guard var player = player else { return }
        view.showLoading(true)
        
        if player.planetIDs.contains(player.planetID) {
            player.planet = player.moonNames[player.currentPlanetIndex]
            player.planetID = player.moonIDs[player.currentPlanetIndex]
            
            view.planetIsChanged(for: player)
        }
        view.showLoading(false)
    }
}
