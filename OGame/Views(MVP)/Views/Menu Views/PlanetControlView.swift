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
                
        leftButton.addTarget(nil, action: #selector(MenuVC.setPreviousPlanet), for: .touchUpInside)
        rightButton.addTarget(nil, action: #selector(MenuVC.setNextPlanet), for: .touchUpInside)
        planetButton.addTarget(nil, action: #selector(MenuVC.planetButtonPressed), for: .touchUpInside)
        moonButton.addTarget(nil, action: #selector(MenuVC.moonButtonPressed), for: .touchUpInside)
    }
}
