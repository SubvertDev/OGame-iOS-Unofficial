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
    
    let menuList = ["Overview", "Resources", "Test Page", "Facilities", "Research", "Shipyard", "Defense", "Fleet", "Galaxy"]
    
    var object: OGame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Menu"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        planetNameLabel.text = object?.planet
        serverNameLabel.text = object?.universe
        rankLabel.text = String(object!.rank())
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
            performSegue(withIdentifier: "ShowTestPageVC", sender: self)
        case 3:
            performSegue(withIdentifier: "ShowFacilitiesVC", sender: self)
        case 4:
            performSegue(withIdentifier: "ShowResearchesVC", sender: self)
        case 5:
            performSegue(withIdentifier: "ShowShipyardVC", sender: self)
        default:
            print(menuList[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: refactor this to switch or something else
        if let overviewVC = segue.destination as? OverviewVC {
            overviewVC.object = object
        }
        if let resourcesVC = segue.destination as? ResourcesVC {
            resourcesVC.object = object
        }
        if let testPageVC = segue.destination as? TestPageVC {
            testPageVC.object = object
        }
        if let facilitiesVC = segue.destination as? FacilitiesVC {
            facilitiesVC.object = object
        }
        if let researchesVC = segue.destination as? ResearchesVC {
            researchesVC.object = object
        }
        if let shipyardVC = segue.destination as? ShipyardVC {
            shipyardVC.object = object
        }
    }
}
