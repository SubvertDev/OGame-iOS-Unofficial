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

    var prodPerSecond = [Double]()
    var timer: Timer?
    var childVC: UIViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureChildVC()
        refresh()
    }

    func configureChildVC() {
        if let childVC = childVC {
            addChild(childVC)
            childVC.view.frame = viewForVC.bounds
            viewForVC.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }

    func refresh() {
        OGame.shared.getResources(forID: 0) { result in
            switch result {
            case .success(let resources):
                self.resourcesOverview.set(metal: resources.metal,
                                           crystal: resources.crystal,
                                           deuterium: resources.deuterium,
                                           energy: resources.energy)

                for day in resources.dayProduction {
                    let dayDouble = Double(day)
                    self.prodPerSecond.append(dayDouble / 3600)
                }

                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.resourcesOverview.update(metal: self.prodPerSecond[0],
                                                  crystal: self.prodPerSecond[1],
                                                  deuterium: self.prodPerSecond[2],
                                                  storage: resources)
                })
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
