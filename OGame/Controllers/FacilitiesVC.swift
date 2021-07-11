//
//  FacilitiesVC.swift
//  OGame
//
//  Created by Subvert on 23.05.2021.
//

import UIKit

class FacilitiesVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    
    var object: OGame?
    var prodPerSecond = [Double]()
    var facilities: Facilities?
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
    
    
    // MARK: - REFRESH DATA ON FACILITIES VC
    func refresh() {
        print(#function)
        object!.getResources(forID: 0) { result in
            print("function: get resources")
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
            print("function: isanybuildingsconstructed")
            switch result {
            case .success(let bool):
                self.isConstructionNow = bool
                
                self.object!.facilities(forID: 0) { result in
                    switch result {
                    case .success(let facilities):
                        self.facilities = facilities
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
    }
}

extension FacilitiesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        
        guard let facilities = self.facilities else { return UITableViewCell() }
        guard let isConstructionNow = self.isConstructionNow else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.setFacility(type: .roboticsFactory, facilities: facilities, isConstructionNow)
        case 1:
            cell.setFacility(type: .shipyard, facilities: facilities, isConstructionNow)
        case 2:
            cell.setFacility(type: .researchLaboratory, facilities: facilities, isConstructionNow)
        case 3:
            cell.setFacility(type: .allianceDepot, facilities: facilities, isConstructionNow)
        case 4:
            cell.setFacility(type: .missileSilo, facilities: facilities, isConstructionNow)
        case 5:
            cell.setFacility(type: .naniteFactory, facilities: facilities, isConstructionNow)
        case 6:
            cell.setFacility(type: .terraformer, facilities: facilities, isConstructionNow)
        case 7:
            cell.setFacility(type: .repairDock, facilities: facilities, isConstructionNow)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FacilitiesVC: BuildingCellDelegate {
    
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        
        object!.build(what: type, id: 0) { result in
            switch result {
            case .success(_):
                self.isConstructionNow = true
                print("successfully builded something")
                self.refresh()
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
