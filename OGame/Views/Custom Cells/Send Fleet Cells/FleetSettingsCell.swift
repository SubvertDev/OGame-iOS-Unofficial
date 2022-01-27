//
//  FleetSettingsCell.swift
//  OGame
//
//  Created by Subvert on 23.01.2022.
//

import UIKit

protocol FleetSettingsCellDelegate: AnyObject {
    func sendButtonPressed(_ sender: UIButton)
}

class FleetSettingsCell: UITableViewCell {
    
    @IBOutlet weak var metalTextField: UITextField!
    @IBOutlet weak var crystalTextField: UITextField!
    @IBOutlet weak var deuteriumTextField: UITextField!
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var cargoLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var delegate: FleetSettingsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        delegate?.sendButtonPressed(sender)
    }
}
