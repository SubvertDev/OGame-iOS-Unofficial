//
//  ResourcesBarView.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

final class ResourcesBarView: UIView {
    
    // MARK: - Properties
    @IBOutlet private weak var metalLabel: UILabel!
    @IBOutlet private weak var crystalLabel: UILabel!
    @IBOutlet private weak var deuteriumLabel: UILabel!
    @IBOutlet private weak var energyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var metal: Double?
    private var crystal: Double?
    private var deuterium: Double?
    private var prodPerSecond: [Double]?
    var currentResources: Resources {
        var resources = resources
        resources!.metal = Int(metal!) // todo fix random fatal error on getCurrentResources from menuView
        resources!.crystal = Int(crystal!)
        resources!.deuterium = Int(deuterium!)
        return resources!
    }
        
    var player: PlayerData?
    var resources: Resources?
    
    private var isFirstLoad: Bool = true
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func updateNew(with resources: Resources) {
        self.resources = resources
        startUpdatingView(with: resources)
    }
    
    func getCurrentResources() -> Resources {
        var resources = resources
        resources!.metal = Int(metal!)
        resources!.crystal = Int(crystal!)
        resources!.deuterium = Int(deuterium!)
        return resources!
    }
    
    // MARK: Private
    private func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "ResourcesTopBarView") else { return }
        view.frame = self.bounds
        addSubview(view)
        view.bringSubviewToFront(activityIndicator)
    }

    // MARK: Private
    private func startUpdatingView(with resources: Resources) {
        set(metal: resources.metal,
            crystal: resources.crystal,
            deuterium: resources.deuterium,
            energy: resources.energy)
        
        var production = [Double]()
        for day in resources.dayProduction {
            let dayDouble = Double(day)
            production.append(dayDouble / 3600)
        }
        prodPerSecond = production
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.update(metal: self.prodPerSecond![0],
                        crystal: self.prodPerSecond![1],
                        deuterium: self.prodPerSecond![2],
                        storage: resources)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func set(metal: Int, crystal: Int, deuterium: Int, energy: Int) {
        self.metalLabel.text = String(metal)
        self.crystalLabel.text = String(crystal)
        self.deuteriumLabel.text = String(deuterium)
        self.energyLabel.text = String(energy)
        
        self.metal = Double(metal)
        self.crystal = Double(crystal)
        self.deuterium = Double(deuterium)
    }
    
    private func update(metal: Double, crystal: Double, deuterium: Double, storage: Resources) {
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
