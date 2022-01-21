//
//  GenericVC.swift
//  OGame
//
//  Created by Subvert on 28.07.2021.
//

import UIKit

class GenericVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var viewForVC: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer: Timer?
    var childVC: UIViewController?
    
    var resources: Resources?
    var prodPerSecond: [Double]?
    var isFirstLoad = true
    
    var player: PlayerData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("Build"), object: nil)
        
        resourcesOverview.bringSubviewToFront(activityIndicator)
        configureChildVC()
    }
    
    // MARK: - Configure UI
    func configureChildVC() {
        if let childVC = childVC {
            addChild(childVC)
            childVC.view.frame = viewForVC.bounds
            viewForVC.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }
    
    func removeChildVC() {
        if let childVC = childVC {
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
    }
    
    // MARK: - Refresh UI
    @objc func refresh() {
        guard let player = player else { return }
        
        resourcesOverview.alpha = 0.5
        activityIndicator.startAnimating()
                
        if isFirstLoad && resources != nil {
            startUpdatingViewWith(resources!)
        } else {
            Task {
                do {
                    let resources = try await OGResources().getResourcesWith(playerData: player)
                    startUpdatingViewWith(resources)
                } catch {
                    logoutAndShowError(error as! OGError)
                }
            }
        }
    }
    
    func startUpdatingViewWith(_ resources: Resources) {
        resourcesOverview.set(metal: resources.metal,
                              crystal: resources.crystal,
                              deuterium: resources.deuterium,
                              energy: resources.energy)
        
        isFirstLoad = false
        resourcesOverview.alpha = 1
        activityIndicator.stopAnimating()
        
        var production = [Double]()
        for day in resources.dayProduction {
            let dayDouble = Double(day)
            production.append(dayDouble / 3600)
        }
        prodPerSecond = production
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.resourcesOverview.update(metal: self.prodPerSecond![0],
                                          crystal: self.prodPerSecond![1],
                                          deuterium: self.prodPerSecond![2],
                                          storage: resources)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
}
