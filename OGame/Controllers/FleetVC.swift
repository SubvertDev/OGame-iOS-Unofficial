//
//  FleetVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

class FleetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OGame.shared.getFleet { result in
            switch result {
            case .success(let success):
                print("ITS WORKING: \(success)")
            case .failure(_):
                print("FATAL ERROR")
            }
        }
    }
}
