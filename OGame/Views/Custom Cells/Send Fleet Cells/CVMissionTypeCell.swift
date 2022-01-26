//
//  CVMissionType.swift
//  OGame
//
//  Created by Subvert on 21.01.2022.
//

import UIKit

class CVMissionTypeCell: UICollectionViewCell {

    @IBOutlet weak var missionTypeImageView: UIImageView!
    @IBOutlet weak var missionTypeLabel: UILabel!
    
    var isActive = false
    var isAvailable = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        missionTypeImageView.layer.cornerRadius = 10
    }
}
