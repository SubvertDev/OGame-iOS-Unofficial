//
//  MenuVC.swift
//  OGame
//
//  Created by Subvert on 19.05.2021.
//

import UIKit

class MenuVC: UIViewController {
        
    @IBOutlet weak var planetControlView: PlanetControlView!
    @IBOutlet weak var resourcesTopBarView: ResourcesTopBarView!
    @IBOutlet weak var tableViewWithRefresh: MenuTableView!
        
    var timer: Timer?
    var resources: Resources?
    var prodPerSecond: [Double]?
    var player: PlayerData?
    
    let menuList = ["Overview",
                    "Resources",
                    "Facilities",
                    "Research",
                    "Shipyard",
                    "Defence",
                    "Fleet",
                    "Movement",
                    "Galaxy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        
        configurePlanetControlView()
        configureResourcesTopBarView()
        configureTableViewWithRefresh()
    }
    
    // MARK: - Configure UI
    func configurePlanetControlView() {
        planetControlView.planetIsChanged = { [weak self] player in
            self?.tableViewWithRefresh.tableView.isUserInteractionEnabled = false
            self?.planetControlView.disableButtons()
            self?.player = player
            self?.resourcesTopBarView.refresh(player)
        }
        planetControlView.configureLabels(with: player)
    }
    
    func configureResourcesTopBarView() {
        resourcesTopBarView.refreshFinished = { [weak self] in
            self?.tableViewWithRefresh.tableView.isUserInteractionEnabled = true
            self?.planetControlView.enableButtons()
            self?.tableViewWithRefresh.refreshControl.endRefreshing()
        }
        resourcesTopBarView.didGetError = { [weak self] error in
            self?.logoutAndShowError(error)
        }
        resourcesTopBarView.configureWith(resources: resources, player: player)
    }
    
    func configureTableViewWithRefresh() {
        tableViewWithRefresh.tableView.delegate = self
        tableViewWithRefresh.tableView.dataSource = self
        tableViewWithRefresh.refreshCallback = { [weak self] in
            self?.resourcesTopBarView.refresh(self?.player)
        }
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Delegate & DataSource
extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.label.text = menuList[indexPath.row]
        cell.label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let player = player else { return }
        
        switch indexPath.row {
        case 0:
            let vc = OverviewVC()
            vc.player = player
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = FleetVC()
            vc.player = player
            navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = MovementVC(player: player)
            //vc.player = player
            navigationController?.pushViewController(vc, animated: true)
        case 8:
            performSegue(withIdentifier: "ShowGalaxyVC", sender: self)
        default:
            performSegue(withIdentifier: "ShowBuildingVC", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BuildingVC {
            vc.resources = resources
            vc.player = player
            
            let page = sender as! Int
            switch page {
            case 1...5:
                vc.buildType = BuildingType.allCases[page - 1]
                vc.title = menuList[page]
            case 6...7:
                break // fleet & movement
            default:
                logoutAndShowError(OGError(message: "Error", detailed: "Unknown segue in menu"))
            }
        } else if let vc = segue.destination as? GalaxyVC {
            vc.player = player
        }
    }
}
