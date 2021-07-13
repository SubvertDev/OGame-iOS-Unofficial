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
    
    var prodPerSecond = [Double]()
    var ships: Ships?
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        
        refresh()
    }
    
    func refresh() {
        print(#function)
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
        
        OGame.shared.ships(forID: 0) { result in
            switch result {
            case .success(let ships):
                self.ships = ships
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        
        cell.delegate = self
        cell.amountTextField.delegate = self
        
        cell.setShip(id: indexPath.row, ships: ships)
        
        return cell // FIXME: text field is not properly reused
    }
    
    
}

extension ShipyardVC: BuildingCellDelegate {
    
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        var typeToBuild = type
        if cell.amountTextField.text == "" || cell.amountTextField.text == "0" {
            typeToBuild = (type.0, 1, type.2)
        } else {
            typeToBuild = (type.0, Int((cell.amountTextField.text)!)!, type.2)
        }
        
        OGame.shared.build(what: typeToBuild, id: 0) { result in
            switch result {
            case .success(_):
                self.refresh()
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
