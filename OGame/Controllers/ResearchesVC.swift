//
//  ResearchesVC.swift
//  OGame
//
//  Created by Subvert on 26.05.2021.
//

import UIKit

class ResearchesVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    
    var object: OGame?
    var prodPerSecond = [Double]()
    var researches: Researches?
    var isResearchingNow: Bool?

    let researchCellTypes: [TypeOfResearch] = [
        .energy,
        .laser,
        .ion,
        .hyperspace,
        .plasma,
        .combustionDrive,
        .impulseDrive,
        .hyperspaceDrive,
        .espionage,
        .computer,
        .astrophysics,
        .researchNetwork,
        .graviton,
        .weapons,
        .shielding,
        .armor
    ]
    
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
        
        object!.research(forID: 0) { result in
            switch result {
            case .success(let researches):
                self.researches = researches
                self.isResearchingNow = false
                for research in researches.allResearches {
                    if research.inConstruction! {
                        self.isResearchingNow = true
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}


extension ResearchesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        
        guard let researches = self.researches else { return UITableViewCell() }
        guard let isResearchingNow = self.isResearchingNow else { return UITableViewCell() }
        cell.delegate = self
        
        cell.setResearch(type: researchCellTypes[indexPath.row], researches: researches, isResearchingNow)
        
        return cell
    }
    
}

extension ResearchesVC: BuildingCellDelegate {
    
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        
        object!.build(what: type, id: 0) { result in
            switch result {
            case .success(_):
                self.isResearchingNow = true
                print("successfully builded something")
                self.refresh()
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
