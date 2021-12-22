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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("Build"), object: nil)
        
        resourcesOverview.bringSubviewToFront(activityIndicator)
        configureChildVC()
        //refresh() no need because childvc calls refresh by notification
    }
    
    func configureChildVC() {
        if let childVC = childVC {
            addChild(childVC)
            childVC.view.frame = viewForVC.bounds
            viewForVC.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }
    
    @objc func refresh() {
        resourcesOverview.alpha = 0.5
        activityIndicator.startAnimating()
        
        if isFirstLoad && resources != nil {
            self.resourcesOverview.set(metal: resources!.metal,
                                       crystal: resources!.crystal,
                                       deuterium: resources!.deuterium,
                                       energy: resources!.energy)
            isFirstLoad = false
        }
        
        Task {
            do {
                let resources = try await OGame.shared.getResources()
                
                self.resourcesOverview.alpha = 1
                self.activityIndicator.stopAnimating()
                
                self.resourcesOverview.set(metal: resources.metal,
                                           crystal: resources.crystal,
                                           deuterium: resources.deuterium,
                                           energy: resources.energy)
                
                var production = [Double]()
                for day in resources.dayProduction {
                    let dayDouble = Double(day)
                    production.append(dayDouble / 3600)
                }
                self.prodPerSecond = production
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.resourcesOverview.update(metal: self.prodPerSecond![0],
                                                  crystal: self.prodPerSecond![1],
                                                  deuterium: self.prodPerSecond![2],
                                                  storage: resources)
                }
                RunLoop.main.add(self.timer!, forMode: .common)
                
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}
