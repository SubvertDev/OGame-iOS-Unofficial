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
    var shipsCell: ShipsCell?
    var timer: Timer?
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
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
                self.shipsCell = ShipsCell(with: ships)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc func refreshTableView() {
        refresh()
    }
}

extension ShipyardVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.amountTextField.delegate = self
        
        guard let shipsCell = self.shipsCell else { return UITableViewCell() }
        
        cell.setShip(id: indexPath.row, shipsTechnologies: shipsCell.shipsTechnologies)
        
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
