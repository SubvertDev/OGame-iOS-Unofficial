//
//  GalaxyPresenter.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import Foundation
import UIKit

protocol GalaxyPresenterDelegate {
    init(view: GalaxyViewDelegate)
    func viewDidLoad(coords: [Int], player: PlayerData)
    func galaxyChanged(coords: [Int], direction: Direction, player: PlayerData)
    func systemChanged(coords: [Int], direction: Direction, player: PlayerData)
    func galaxyTextFieldChanged(coords: [Int], player: PlayerData, sender: UITextField)
    func systemTextFieldChanged(coords: [Int], player: PlayerData, sender: UITextField)
}

enum Direction {
    case left, right
}

final class GalaxyPresenter: GalaxyPresenterDelegate {
    
    unowned let view: GalaxyViewDelegate
    private let galaxyProvider = GalaxyProvider()
    
    init(view: GalaxyViewDelegate) {
        self.view = view
    }
    
    // MARK: - View Did Load
    func viewDidLoad(coords: [Int], player: PlayerData) {
        view.showLoading(true)
        Task {
            do {
                let systemInfo = try await galaxyProvider.getGalaxyWith(coordinates: coords, playerData: player)
                await MainActor.run { view.reloadTable(with: systemInfo) }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
            await MainActor.run { view.showLoading(false) }
        }
    }
    
    // MARK: - Galaxy Changed
    func galaxyChanged(coords: [Int], direction: Direction, player: PlayerData) {
        var targetCoords = coords
        switch direction {
        case .left:
            if coords[0] - 1 == 0 {
                targetCoords = [4, coords[1]]
            } else {
                targetCoords = [coords[0] - 1, coords[1]]
            }
        case .right:
            if coords[0] + 1 == 5 {
                targetCoords = [1, coords[1]]
            } else {
                targetCoords = [coords[0] + 1, coords[1]]
            }
        }
        view.updateTextFields(with: targetCoords, type: .galaxy)
        updateSystemInfo(for: targetCoords, player: player)
    }
    
    // MARK: - System Changed
    func systemChanged(coords: [Int], direction: Direction, player: PlayerData) {
        var targetCoords = coords
        switch direction {
        case .left:
            if coords[1] - 1 == 0 {
                targetCoords = [coords[0], 499]
            } else {
                targetCoords = [coords[0], coords[1] - 1]
            }
        case .right:
            if targetCoords[1] + 1 == 500 {
                targetCoords = [coords[0], 1]
            } else {
                targetCoords = [coords[0], coords[1] + 1]
            }
        }
        view.updateTextFields(with: targetCoords, type: .system)
        updateSystemInfo(for: targetCoords, player: player)
    }
    
    // MARK: - Galaxy Text Field Changed
    func galaxyTextFieldChanged(coords: [Int], player: PlayerData, sender: UITextField) {
        if sender.text != "" {
            if Int(sender.text!)! > 4 {
                sender.text = "4"
            } else if Int(sender.text!)! < 1 {
                sender.text = "1"
            }
            let targetCoords = [Int(sender.text!)!, coords[1]]
            updateSystemInfo(for: targetCoords, player: player)
            
        } else {
            sender.text = "\(coords[0])"
        }
    }
    
    // MARK: - System Text Field Changed
    func systemTextFieldChanged(coords: [Int], player: PlayerData, sender: UITextField) {
        if sender.text != "" {
            if Int(sender.text!)! > 499 {
                sender.text = "499"
            } else if Int(sender.text!)! < 1 {
                sender.text = "1"
            }
            let targetCoords = [coords[0], Int(sender.text!)!]
            updateSystemInfo(for: targetCoords, player: player)
            
        } else {
            sender.text = "\(coords[1])"
        }
    }
    
    // MARK: - Update System Info
    private func updateSystemInfo(for coords: [Int], player: PlayerData) {
        view.showLoading(true)
        Task {
            do {
                let planets = try await galaxyProvider.getGalaxyWith(coordinates: coords, playerData: player)
                await MainActor.run {
                    view.reloadTable(with: planets)
                    view.showLoading(false)
                }
            } catch {
                await MainActor.run { view.showAlert(error: error as! OGError) }
            }
        }
    }
}
