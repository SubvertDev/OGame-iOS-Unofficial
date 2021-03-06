//
//  MissionSettingsCell.swift
//  OGame
//
//  Created by Subvert on 22.01.2022.
//

import UIKit

final class MissionBriefingCell: UITableViewCell {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var deuteriumLabel: UILabel!
    @IBOutlet weak var cargobaysLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        durationLabel.isHidden = true
        arrivalLabel.isHidden = true
        returnLabel.isHidden = true
        deuteriumLabel.isHidden = true
        cargobaysLabel.isHidden = true
        speedLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
