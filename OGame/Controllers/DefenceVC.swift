//
//  DefenceVC.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

class DefenceVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    
    var prodPerSecond = [Double]()
    var defencesCell: DefenceCell?
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
    
    
    // MARK: - REFRESH DATA ON SHIPYARD VC
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
        
        OGame.shared.defences(forID: 0) { result in
            switch result {
            case .success(let defences):
                self.defencesCell = DefenceCell(with: defences)
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


extension DefenceVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.amountTextField.delegate = self
        
        guard let defencesCell = self.defencesCell else { return UITableViewCell() }
        
        cell.setDefence(id: indexPath.row, defenceTechnologies: defencesCell.defenceTechnologies)
        
        return cell // FIXME: text field is not properly reused
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DefenceVC: BuildingCellDelegate {
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
