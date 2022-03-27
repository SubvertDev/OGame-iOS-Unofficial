//
//  ResourcesTopBarView.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

protocol IResourcesTopBarView {
    func refreshFinished()
    func didGetError(error: OGError)
}

@IBDesignable final class ResourcesTopBarView: UIView {
    
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
    
    var delegate: IResourcesTopBarView?
    
    var player: PlayerData?
    var resources: Resources?
    
    private var isFirstLoad: Bool = true
    private var timer: Timer?
    
    var refreshFinished: (() -> Void)?
    var didGetError: ((OGError) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("coder init resources")
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
        
    private func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "ResourcesTopBarView") else { return }
        view.frame = self.bounds
        addSubview(view)
        view.bringSubviewToFront(activityIndicator)
    }
    
    func updateNew(with resources: Resources) {
        self.resources = resources
        startUpdatingViewWith(resources)
    }
    
    
    // MARK: - LEGACY, DELETE AND USE -> configureNew() (rename it after delete)
    // must be used in presenter
    func configureWith(resources: Resources?, player: PlayerData?) {
        guard let player = player else { return }
        self.resources = resources
        self.player = player
        refresh(player)
    }
    
    // MARK: - LEGACY, DELETE AFTER DELETING configureWith()
    // must be used in presenter
    func refresh(_ player: PlayerData? = nil) {
        guard let player = player else { return }
        
        Task {
            do {
                resources = try await ResourcesProvider().getResourcesWith(playerData: player)
                startUpdatingViewWith(resources!)
                refreshFinished?()
            } catch {
                didGetError?(error as! OGError)
            }
        }
    }
    
    // MARK: - Start Updating
    func startUpdatingViewWith(_ resources: Resources) {
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
    
    // MARK: - Set
    func set(metal: Int, crystal: Int, deuterium: Int, energy: Int) {
        self.metalLabel.text = String(metal)
        self.crystalLabel.text = String(crystal)
        self.deuteriumLabel.text = String(deuterium)
        self.energyLabel.text = String(energy)
        
        self.metal = Double(metal)
        self.crystal = Double(crystal)
        self.deuterium = Double(deuterium)
    }
    
    // MARK: - Update
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
