//
//  SendFleetCell.swift
//  OGame
//
//  Created by Subvert on 13.01.2022.
//

import UIKit

class SendFleetCell: UITableViewCell {

    @IBOutlet weak var shipImageView: UIImageView!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipAvailableLabel: UILabel!
    @IBOutlet weak var shipSelectedTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shipImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setShip(with ship: BuildingWithAmount) {
        shipNameLabel.text = ship.name
        shipAvailableLabel.text = "\(ship.amount)"
        if ship.amount != 0 {
            shipImageView.image = ship.image.available
            shipSelectedTextField.isEnabled = true
        } else {
            shipImageView.image = ship.image.disabled
            shipSelectedTextField.isEnabled = false
        }
    }
    
    @IBAction func shipTextFieldChanged(_ sender: UITextField) {
        if Int(sender.text!) ?? 0 > Int(shipAvailableLabel.text!)! {
            sender.text = shipAvailableLabel.text
        }
    }
}
