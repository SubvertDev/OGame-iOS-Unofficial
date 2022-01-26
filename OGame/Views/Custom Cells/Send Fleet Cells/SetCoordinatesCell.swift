//
//  SetCoordinatesCell.swift
//  OGame
//
//  Created by Subvert on 21.01.2022.
//

import UIKit

protocol SetCoordinatesCellDelegate: AnyObject {
    func didPressButton(_ sender: UIButton)
}

class SetCoordinatesCell: UITableViewCell {
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var myPlanetButton: UIButton!
    @IBOutlet weak var myMoonButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var targetPlanetButton: UIButton!
    @IBOutlet weak var targetMoonButton: UIButton!
    @IBOutlet weak var targetDebrisButton: UIButton!
    
    @IBOutlet weak var galaxyCoordinateTextField: UITextField!
    @IBOutlet weak var systemCoordinateTextField: UITextField!
    @IBOutlet weak var destinationCoordinateTextField: UITextField!
    
    var myPlanetActive = true
    var myMoonActive = false
    var targetPlanetActive = true
    var targetMoonActive = false
    var targetDebrisActive = false
    
    var delegate: SetCoordinatesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBActions
    @IBAction func myPlanetButtonPressed(_ sender: UIButton) {
        if !myPlanetActive {
            myPlanetButton.setImage(UIImage(named: "planetAvailable"), for: .normal)
            myMoonButton.setImage(UIImage(named: "moonUnavailable"), for: .normal)
            myPlanetActive = true
            myMoonActive = false
            delegate?.didPressButton(sender)
        }
    }
    
    @IBAction func myMoonButtonPressed(_ sender: UIButton) {
        if !myMoonActive {
            myMoonButton.setImage(UIImage(named: "moonAvailable"), for: .normal)
            myPlanetButton.setImage(UIImage(named: "planetUnavailable"), for: .normal)
            myMoonActive = true
            myPlanetActive = false
            delegate?.didPressButton(sender)
        }
    }
    
    @IBAction func targetPlanetButtonPressed(_ sender: UIButton) {
        if targetPlanetButton.currentImage?.pngData() == UIImage(named: "planetUnavailable")?.pngData() {
            targetPlanetButton.setImage(UIImage(named: "planetAvailable"), for: .normal)
            targetMoonButton.setImage(UIImage(named: "moonUnavailable"), for: .normal)
            targetDebrisButton.setImage(UIImage(named: "debrisUnavailable"), for: .normal)
            targetPlanetActive = true
            targetMoonActive = false
            targetDebrisActive = false
            delegate?.didPressButton(sender)
        }
    }
    
    @IBAction func targetMoonButtonPressed(_ sender: UIButton) {
        if targetMoonButton.currentImage?.pngData() == UIImage(named: "moonUnavailable")?.pngData() {
            targetPlanetButton.setImage(UIImage(named: "planetUnavailable"), for: .normal)
            targetMoonButton.setImage(UIImage(named: "moonAvailable"), for: .normal)
            targetDebrisButton.setImage(UIImage(named: "debrisUnavailable"), for: .normal)
            targetPlanetActive = false
            targetMoonActive = true
            targetDebrisActive = false
            delegate?.didPressButton(sender)
        }
    }
    
    @IBAction func targetDebrisButtonPressed(_ sender: UIButton) {
        if targetDebrisButton.currentImage?.pngData() == UIImage(named: "debrisUnavailable")?.pngData() {
            targetPlanetButton.setImage(UIImage(named: "planetUnavailable"), for: .normal)
            targetMoonButton.setImage(UIImage(named: "moonUnavailable"), for: .normal)
            targetDebrisButton.setImage(UIImage(named: "debrisAvailable"), for: .normal)
            targetPlanetActive = false
            targetMoonActive = false
            targetDebrisActive = true
            delegate?.didPressButton(sender)
        }
    }
}
