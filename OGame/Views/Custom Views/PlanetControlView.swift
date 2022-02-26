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
    @IBOutlet weak var planetButton: UIButton!
    @IBOutlet weak var moonButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var player: PlayerData?
    var planetIsChanged: ((_ player: PlayerData) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Configure UI
    func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "PlanetControlView") else { return }
        addSubview(view)
        view.frame = self.bounds
        
        configureLabels(with: player)
    }
    
    func configureLabels(with player: PlayerData?) {
        guard let player = player else { return }
        
        self.player = player

        serverNameLabel.text = player.universe
        rankLabel.text = "Rank: \(String(player.rank))"
        planetNameLabel.text = player.planet
        
        if player.planetIDs.contains(player.planetID) {
            let currentPlanet = player.celestials[player.currentPlanetIndex]
            if currentPlanet.moon == nil {
                moonButton.isHidden = true
            } else {
                moonButton.isHidden = false
            }
            coordinatesLabel.text = "[\(currentPlanet.coordinates[0]):\(currentPlanet.coordinates[1]):\(currentPlanet.coordinates[2])]"
            fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
            planetButton.setImage(player.planetImages[player.currentPlanetIndex], for: .normal)
            moonButton.setImage(player.moonImages[player.currentPlanetIndex], for: .normal)
        } else if player.moonIDs.contains(player.planetID) {
            guard let currentPlanet = player.celestials[player.currentPlanetIndex].moon else { return }
            planetNameLabel.text = "\(player.planet) (moon)"
            coordinatesLabel.text = "[\(currentPlanet.coordinates[0]):\(currentPlanet.coordinates[1]):\(currentPlanet.coordinates[2])]"
            fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
            planetButton.setImage(player.planetImages[player.currentPlanetIndex], for: .normal)
            moonButton.setImage(player.moonImages[player.currentPlanetIndex], for: .normal)
            moonButton.isHidden = false
        }
        
        switch player.celestials.count {
        case 1:
            leftButton.isHidden = true
            rightButton.isHidden = true
            
        case 2:
            if player.currentPlanetIndex == 0 {
                let planetName = player.planetNames[player.currentPlanetIndex + 1]
                let coordinates = player.celestials[player.currentPlanetIndex + 1].coordinates
                let editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
                
                rightButton.isEnabled = true
                rightButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
                rightButton.setTitleColor(.white, for: .normal)
                rightButton.titleLabel?.textAlignment = .center
                
                leftButton.isEnabled = false
                leftButton.setTitle("", for: .normal)
            } else {
                let planetName = player.planetNames[player.currentPlanetIndex - 1]
                let coordinates = player.celestials[player.currentPlanetIndex - 1].coordinates
                let editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
                
                leftButton.isEnabled = true
                leftButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
                leftButton.setTitleColor(.white, for: .normal)
                leftButton.titleLabel?.textAlignment = .center
                
                rightButton.isEnabled = false
                rightButton.setTitle("", for: .normal)
            }
            
        case 3...100:
            var planetName = ""
            var coordinates = [Int]()
            var editedCoordinates = ""
            
            if player.currentPlanetIndex + 1 == player.planetNames.count {
                planetName = player.planetNames[0]
                coordinates = player.celestials[0].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            } else {
                planetName = player.planetNames[player.currentPlanetIndex + 1]
                coordinates = player.celestials[player.currentPlanetIndex + 1].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            }
            rightButton.isEnabled = true
            rightButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
            rightButton.setTitleColor(.white, for: .normal)
            rightButton.titleLabel?.textAlignment = .center
            
            if player.currentPlanetIndex == 0 {
                planetName = player.planetNames.last!
                coordinates = player.celestials.last!.coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            } else {
                planetName = player.planetNames[player.currentPlanetIndex - 1]
                coordinates = player.celestials[player.currentPlanetIndex - 1].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            }
            leftButton.isEnabled = true
            leftButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
            leftButton.setTitleColor(.white, for: .normal)
            leftButton.titleLabel?.textAlignment = .center
            
        default:
            break
        }
    }
    
    // MARK: - IBActions
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
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
        
        disableButtons()
        configureLabels(with: player)
        planetIsChanged?(player)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
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
        
        disableButtons()
        configureLabels(with: player)
        planetIsChanged?(player)
    }
    
    @IBAction func planetButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }

        if player.moonIDs.contains(player.planetID) {
            player.planet = player.planetNames[player.currentPlanetIndex]
            player.planetID = player.planetIDs[player.currentPlanetIndex]
            
            disableButtons()
            configureLabels(with: player)
            planetIsChanged?(player)
        }
    }
    
    @IBAction func moonButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }

        if player.planetIDs.contains(player.planetID) {
            player.planet = player.moonNames[player.currentPlanetIndex]
            player.planetID = player.moonIDs[player.currentPlanetIndex]
            
            disableButtons()
            configureLabels(with: player)
            planetIsChanged?(player)
        }
    }
    
    // MARK: - Support Functions
    func enableButtons() {
        leftButton.isEnabled = true
        rightButton.isEnabled = true
    }
    
    func disableButtons() {
        leftButton.isEnabled = false
        rightButton.isEnabled = false
    }
}
