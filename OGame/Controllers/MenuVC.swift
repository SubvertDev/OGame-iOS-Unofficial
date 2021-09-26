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
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var planetImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let menuList = ["Overview",
                    "Resources",
                    "Facilities",
                    "Research",
                    "Shipyard",
                    "Defence",
                    "Fleet",
                    "Galaxy",
                    "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        configureTableView()
        configureLabels()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        OGame.shared.setNextPlanet { error in
            if let _ = error {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.configureLabels()
            }
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        OGame.shared.setPreviousPlanet { error in
            if let _ = error {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.configureLabels()
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
    }
    
    func configureLabels() {
        planetNameLabel.text = OGame.shared.planet
        serverNameLabel.text = OGame.shared.universe
        rankLabel.text = "Rank: \(OGame.shared.rank!)"
        fieldsLabel.text = "\(OGame.shared.celestial!.used)/\(OGame.shared.celestial!.total)"
        coordinatesLabel.text = "[\(OGame.shared.celestial!.coordinates[0]):\(OGame.shared.celestial!.coordinates[1]):\(OGame.shared.celestial!.coordinates[2])]"
        planetImage.image = OGame.shared.planetImage
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
        
        if indexPath.row == 7 {
            performSegue(withIdentifier: "ShowGalaxyVC", sender: self)
        } else {
            performSegue(withIdentifier: "ShowGenericVC", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GenericVC {
            let page = sender as! Int
            switch page {
            case 0:
                vc.childVC = OverviewVC()
                vc.title = menuList[page]
            case 1:
                vc.childVC = ResourcesVC()
                vc.title = menuList[page]
            case 2:
                vc.childVC = FacilitiesVC()
                vc.title = menuList[page]
            case 3:
                vc.childVC = ResearchVC()
                vc.title = menuList[page]
            case 4:
                vc.childVC = ShipyardVC()
                vc.title = menuList[page]
            case 5:
                vc.childVC = DefenceVC()
                vc.title = menuList[page]
            case 6:
                vc.childVC = FleetVC()
                vc.title = menuList[page]
            case 7:
                vc.childVC = GalaxyVC()
                vc.title = menuList[page]
            default:
                print(sender as! Int)
            }
        }
    }
}
