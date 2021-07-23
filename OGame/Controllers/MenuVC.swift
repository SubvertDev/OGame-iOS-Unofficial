//
//  MenuVC.swift
//  OGame
//
//  Created by Subvert on 19.05.2021.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuList = ["Overview",
                    "Resources",
                    "Facilities",
                    "Research",
                    "Shipyard",
                    "Defence",
                    "Fleet",
                    "Galaxy"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Menu"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        planetNameLabel.text = OGame.shared.planet
        serverNameLabel.text = OGame.shared.universe
        rankLabel.text = OGame.shared.rank()
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "ShowOverviewVC", sender: self)
        case 1:
            performSegue(withIdentifier: "ShowResourcesVC", sender: self)
        case 2:
            performSegue(withIdentifier: "ShowFacilitiesVC", sender: self)
        case 3:
            performSegue(withIdentifier: "ShowResearchVC", sender: self)
        case 4:
            performSegue(withIdentifier: "ShowShipyardVC", sender: self)
        case 5:
            performSegue(withIdentifier: "ShowDefenceVC", sender: self)
        default:
            print(menuList[indexPath.row])
        }
    }
}
