//
//  ShipyardVC.swift
//  OGame
//
//  Created by Subvert on 30.05.2021.
//

import UIKit

class ShipyardVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    
    var object: OGame?
    var prodPerSecond = [Double]()
    var ships: Ships?
    var isConstructionNow: Bool?
    
    var timer: Timer?
    
    let shipsCellType: [TypeOfShip] = [
        .lightFighter,
        .heavyFighter,
        .cruiser,
        .battleship,
        .interceptor,
        .bomber,
        .destroyer,
        .deathstar,
        .reaper,
        .explorer,
        .smallTransporter,
        .largeTransporter,
        .colonyShip,
        .recycler,
        .espionageProbe,
        .solarSatellite,
        .crawler
    ]
    
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
    
    func refresh() {
        print(#function)
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
        
        object!.ships(forID: 0) { result in
            switch result {
            case .success(let ships):
                self.ships = ships
                self.isConstructionNow = false
                for ship in ships.allShips {
                    if ship.inConstruction! {
                        self.isConstructionNow = true
                        break
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}

extension ShipyardVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        
        guard let ships = self.ships else { return UITableViewCell() }
        guard let isConstructionNow = self.isConstructionNow else { return UITableViewCell() }
        
        cell.delegate = self
        cell.amountTextField.delegate = self
        
        cell.setShip(type: shipsCellType[indexPath.row], ships: ships, isConstructionNow)
        
        return cell // FIXME: text field is not properly reused
    }

    
}

extension ShipyardVC: BuildingCellDelegate {
    
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        var newType = type
        if cell.amountTextField.text == "" || cell.amountTextField.text == "0" {
            newType = (type.0, 1, type.2)
        } else {
            newType = (type.0, Int((cell.amountTextField.text)!)!, type.2)
        }
        print("new type is \(newType)")
        
        object!.build(what: newType, id: 0) { result in
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
