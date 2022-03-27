//
//  PlanetControlView.swift
//  OGame
//
//  Created by Subvert on 30.01.2022.
//

import UIKit

protocol IPlanetControlView {
    func previousPlanetButtonTapped()
    func nextPlanetButtonTapped()
    func planetButtonTapped()
    func moonButtonTapped()
}

@IBDesignable final class PlanetControlView: UIView {
    
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var planetButton: UIButton!
    @IBOutlet weak var moonButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: IPlanetControlView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: Public
    func updateView(with player: PlayerData) {
        serverNameLabel.text = player.universe
        rankLabel.text = "Rank: \(String(player.rank))"
        planetNameLabel.text = player.planet
        
        if player.planetIDs.contains(player.planetID) {
            let currentPlanet = player.celestials[player.currentPlanetIndex]
            let coordinates = currentPlanet.coordinates
            if currentPlanet.moon == nil {
                moonButton.isHidden = true
            } else {
                moonButton.isHidden = false
            }
            coordinatesLabel.text = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
            planetButton.setImage(player.planetImages[player.currentPlanetIndex], for: .normal)
            moonButton.setImage(player.moonImages[player.currentPlanetIndex], for: .normal)
            
        } else if player.moonIDs.contains(player.planetID) {
            guard let currentPlanet = player.celestials[player.currentPlanetIndex].moon else { return }
            let coordinates = currentPlanet.coordinates
            planetNameLabel.text = "\(player.planet) (moon)"
            coordinatesLabel.text = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
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
            
        case 3...:
            var planetName: String
            var coordinates: [Int]
            var editedCoordinates: String
            
            if player.currentPlanetIndex + 1 == player.planetNames.count {
                planetName = player.planetNames[0]
                coordinates = player.celestials[0].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            } else {
                planetName = player.planetNames[player.currentPlanetIndex + 1]
                coordinates = player.celestials[player.currentPlanetIndex + 1].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            }
            // REMOVE TO HAVE FAST PLANET SWITCHING (MESSING UP RESOURCES LOADING)
            //rightButton.isEnabled = true
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
            // REMOVE TO HAVE FAST PLANET SWITCHING (MESSING UP RESOURCES LOADING)
            //leftButton.isEnabled = true
            leftButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
            leftButton.setTitleColor(.white, for: .normal)
            leftButton.titleLabel?.textAlignment = .center
            
        default:
            break
        }
    }
    
    // MARK: Private
    private func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "PlanetControlView") else { return }
        addSubview(view)
        view.frame = self.bounds
        
        leftButton.addTarget(self, action: #selector(previousPlanetButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(nextPlanetButtonTapped), for: .touchUpInside)
        planetButton.addTarget(self, action: #selector(planetButtonTapped), for: .touchUpInside)
        moonButton.addTarget(self, action: #selector(moonButtonTapped), for: .touchUpInside)
    }
    
    @objc private func previousPlanetButtonTapped() {
        delegate?.previousPlanetButtonTapped()
    }
    
    @objc private func nextPlanetButtonTapped() {
        delegate?.nextPlanetButtonTapped()
    }
    
    @objc private func planetButtonTapped() {
        delegate?.planetButtonTapped()
    }
    
    @objc private func moonButtonTapped() {
        delegate?.moonButtonTapped()
    }
}
