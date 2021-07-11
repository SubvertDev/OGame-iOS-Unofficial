//
//  ResourcesVC.swift
//  OGame
//
//  Created by Subvert on 19.05.2021.
//

import UIKit

class ResourcesVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    
    var object: OGame?
    var prodPerSecond = [Double]()
    var supplies: Supplies?
    var isConstructionNow: Bool?
    
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = object else {
            fatalError("error initialazing main object")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        
        refresh()
    }
    
    
    // MARK: - REFRESH DATA ON RESOURCES VC
    func refresh() {
        //print(#function)
        object!.getResources(forID: 0) { result in
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
        
        object!.isAnyBuildingsConstructed(forID: 0) { result in
            //print(#function)
            switch result {
            case .success(let bool):
                self.isConstructionNow = bool
                
                self.object!.supply(forID: 0) { result in
                    switch result {
                    case .success(let supplies):
                        self.supplies = supplies
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(_):
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
//        object!.supply(forID: 0) { result in
//            switch result {
//            case .success(let supplies):
//                for supply in supplies.allSupplies {
//                    if supply.inConstruction! {
//                        self.isConstructionNow = true
//                    }
//                }
//                self.supplies = supplies
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .failure(_):
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
}


extension ResourcesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print(#function)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        // TODO: refactor this somewhere to buildingcell
        guard let supplies = self.supplies else { return UITableViewCell() }
        guard let isConstructionNow = self.isConstructionNow else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.setSupply(type: .metalMine, supplies: supplies, isConstructionNow)
        case 1:
            cell.setSupply(type: .crystalMine, supplies: supplies, isConstructionNow)
        case 2:
            cell.setSupply(type: .deuteriumMine, supplies: supplies, isConstructionNow)
        case 3:
            cell.setSupply(type: .solarPlant, supplies: supplies, isConstructionNow)
        case 4:
            cell.setSupply(type: .fusionPlant, supplies: supplies, isConstructionNow)
        case 5:
            cell.setSupply(type: .metalStorage, supplies: supplies, isConstructionNow)
        case 6:
            cell.setSupply(type: .crystalStorage, supplies: supplies, isConstructionNow)
        case 7:
            cell.setSupply(type: .deuteriumStorage, supplies: supplies, isConstructionNow)
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ResourcesVC: BuildingCellDelegate {
    
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        
        object!.build(what: type, id: 0) { result in
            switch result {
            case .success(_):
                self.isConstructionNow = true
                self.refresh()
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
