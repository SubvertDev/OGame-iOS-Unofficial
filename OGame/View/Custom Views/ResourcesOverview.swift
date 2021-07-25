//
//  ResourcesOverview.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

class ResourcesOverview: UIView {
    
    @IBOutlet private weak var metalLabel: UILabel!
    @IBOutlet private weak var crystalLabel: UILabel!
    @IBOutlet private weak var deuteriumLabel: UILabel!
    @IBOutlet private weak var energyLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIStackView!

    private var metal: Double?
    private var crystal: Double?
    private var deuterium: Double?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    private func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "ResourcesOverview") else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

    func set(metal: Int, crystal: Int, deuterium: Int, energy: Int) {
        self.metalLabel.text = String(metal)
        self.crystalLabel.text = String(crystal)
        self.deuteriumLabel.text = String(deuterium)
        self.energyLabel.text = String(energy)

        self.metal = Double(metal)
        self.crystal = Double(crystal)
        self.deuterium = Double(deuterium)
    }

    func update(metal: Double, crystal: Double, deuterium: Double, storage: Resources) {
        if Int(self.metal!) < storage.storage[0] {
            self.metal! += metal
        }
        if Int(self.crystal!) < storage.storage[1] {
            self.crystal! += crystal
        }
        if Int(self.deuterium!) < storage.storage[2] {
            self.deuterium! += deuterium
        }
        
        self.metalLabel.text = String(Int(self.metal!))
        self.crystalLabel.text = String(Int(self.crystal!))
        self.deuteriumLabel.text = String(Int(self.deuterium!))
    }
}
