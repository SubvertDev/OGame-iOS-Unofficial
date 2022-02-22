//
//  PlanetControlView.swift
//  OGame
//
//  Created by Subvert on 30.01.2022.
//

import UIKit

@IBDesignable class PlanetControlView: UIView {
    
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var player: PlayerData?
    var planetWasChanged: ((_ player: PlayerData) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "PlanetControlView") else { return }
        addSubview(view)
        view.frame = self.bounds
        
        configureLabels(with: player)
    }
    
    func configureLabels(with player: PlayerData?) {
        guard let player = player else { return }
        
        self.player = player

        let currentPlanet = player.celestials[player.currentPlanetIndex]
        serverNameLabel.text = player.universe
        rankLabel.text = "Rank: \(String(player.rank))"
        planetNameLabel.text = player.planet
        coordinatesLabel.text = "[\(currentPlanet.coordinates[0]):\(currentPlanet.coordinates[1]):\(currentPlanet.coordinates[2])]"
        fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
        planetImageView.image = player.planetImages[player.currentPlanetIndex]
        
        if player.celestials.count == 1 {
            leftButton.isHidden = true
            rightButton.isHidden = true
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
        if let index = player.planetNames.firstIndex(of: player.planet) {
            if index + 1 == player.planetNames.count {
                player.currentPlanetIndex = 0
                player.planet = player.planetNames[0]
                player.planetID = player.planetIDs[0]
            } else {
                player.currentPlanetIndex += 1
                player.planet = player.planetNames[index + 1]
                player.planetID = player.planetIDs[index + 1]
            }
        }
        
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        
        configureLabels(with: player)
        planetWasChanged?(player)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
        if let index = player.planetNames.firstIndex(of: player.planet) {
            if index - 1 == -1 {
                player.currentPlanetIndex = player.planetNames.count - 1
                player.planet = player.planetNames.last!
                player.planetID = player.planetIDs.last!
            } else {
                player.currentPlanetIndex -= 1
                player.planet = player.planetNames[index - 1]
                player.planetID = player.planetIDs[index - 1]
            }
        }
        
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        
        configureLabels(with: player)
        planetWasChanged?(player)
    }
}
