//
//  MenuVC.swift
//  OGame
//
//  Created by Subvert on 19.05.2021.
//

import UIKit

protocol MenuViewDelegate: AnyObject {
    func showLoading(_ state: Bool)
    func showAlert(error: Error)
    func refreshResourcesTopBarView(with: PlayerData?)
    func planetIsChanged(for: PlayerData)
}

final class MenuVC: UIViewController {
        
    @IBOutlet weak var planetControlView: PlanetControlView!
    @IBOutlet weak var resourcesTopBarView: ResourcesTopBarView!
    @IBOutlet weak var tableViewWithRefresh: MenuTableView!
    
    private var menuPresenter: MenuPresenter!
    private var timer: Timer?
    private var prodPerSecond: [Double]?
    var resources: Resources?
    var player: PlayerData?
    
    let menuList = ["Overview", "Resources", "Facilities",
                    "Research", "Shipyard", "Defence",
                    "Fleet", "Movement", "Galaxy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        
        menuPresenter = MenuPresenter(view: self)        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resourcesTopBarView.configureWith(resources: nil, player: player)
    }
    
    // MARK: - Configure Views
    func configureViews() {
        configurePlanetControlView(with: player)
        resourcesTopBarView.configureWith(resources: resources, player: player)
        tableViewWithRefresh.tableView.delegate = self
        tableViewWithRefresh.tableView.dataSource = self
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Actions
    @objc func setPreviousPlanet() {
        menuPresenter.setPreviousPlanet(for: player)
    }
    
    @objc func setNextPlanet() {
        menuPresenter.setNextPlanet(for: player)
    }
    
    @objc func planetButtonPressed() {
        menuPresenter.planetButtonPressed(for: player)
    }
    
    @objc func moonButtonPressed() {
        menuPresenter.moonButtonPressed(for: player)
    }
    
    @objc func tableViewRefreshCalled() {
        refreshResourcesTopBarView(with: nil)
    }
    
    // MARK: - Configure Planet Control
    // TODO: Refactor this one to presenter?
    func configurePlanetControlView(with player: PlayerData?) {
        guard let player = player else { return }
        
        self.player = player

        planetControlView.serverNameLabel.text = player.universe
        planetControlView.rankLabel.text = "Rank: \(String(player.rank))"
        planetControlView.planetNameLabel.text = player.planet
        
        if player.planetIDs.contains(player.planetID) {
            let currentPlanet = player.celestials[player.currentPlanetIndex]
            let coordinates = currentPlanet.coordinates
            if currentPlanet.moon == nil {
                planetControlView.moonButton.isHidden = true
            } else {
                planetControlView.moonButton.isHidden = false
            }
            planetControlView.coordinatesLabel.text = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            planetControlView.fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
            planetControlView.planetButton.setImage(player.planetImages[player.currentPlanetIndex], for: .normal)
            planetControlView.moonButton.setImage(player.moonImages[player.currentPlanetIndex], for: .normal)
            
        } else if player.moonIDs.contains(player.planetID) {
            guard let currentPlanet = player.celestials[player.currentPlanetIndex].moon else { return }
            let coordinates = currentPlanet.coordinates
            planetControlView.planetNameLabel.text = "\(player.planet) (moon)"
            planetControlView.coordinatesLabel.text = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            planetControlView.fieldsLabel.text = "\(currentPlanet.used)/\(currentPlanet.total)"
            planetControlView.planetButton.setImage(player.planetImages[player.currentPlanetIndex], for: .normal)
            planetControlView.moonButton.setImage(player.moonImages[player.currentPlanetIndex], for: .normal)
            planetControlView.moonButton.isHidden = false
        }
        
        switch player.celestials.count {
        case 1:
            planetControlView.leftButton.isHidden = true
            planetControlView.rightButton.isHidden = true
            
        case 2:
            if player.currentPlanetIndex == 0 {
                let planetName = player.planetNames[player.currentPlanetIndex + 1]
                let coordinates = player.celestials[player.currentPlanetIndex + 1].coordinates
                let editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
                
                planetControlView.rightButton.isEnabled = true
                planetControlView.rightButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
                planetControlView.rightButton.setTitleColor(.white, for: .normal)
                planetControlView.rightButton.titleLabel?.textAlignment = .center
                
                planetControlView.leftButton.isEnabled = false
                planetControlView.leftButton.setTitle("", for: .normal)
            } else {
                let planetName = player.planetNames[player.currentPlanetIndex - 1]
                let coordinates = player.celestials[player.currentPlanetIndex - 1].coordinates
                let editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
                
                planetControlView.leftButton.isEnabled = true
                planetControlView.leftButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
                planetControlView.leftButton.setTitleColor(.white, for: .normal)
                planetControlView.leftButton.titleLabel?.textAlignment = .center
                
                planetControlView.rightButton.isEnabled = false
                planetControlView.rightButton.setTitle("", for: .normal)
            }
            
        case 3...100:
            var planetName = ""
            var coordinates = [Int]()
            var editedCoordinates = ""
            
            if player.currentPlanetIndex + 1 == player.planetNames.count {
                planetName = player.planetNames[0]
                coordinates = player.celestials[0].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            } else {
                planetName = player.planetNames[player.currentPlanetIndex + 1]
                coordinates = player.celestials[player.currentPlanetIndex + 1].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            }
            planetControlView.rightButton.isEnabled = true
            planetControlView.rightButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
            planetControlView.rightButton.setTitleColor(.white, for: .normal)
            planetControlView.rightButton.titleLabel?.textAlignment = .center
            
            if player.currentPlanetIndex == 0 {
                planetName = player.planetNames.last!
                coordinates = player.celestials.last!.coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            } else {
                planetName = player.planetNames[player.currentPlanetIndex - 1]
                coordinates = player.celestials[player.currentPlanetIndex - 1].coordinates
                editedCoordinates = "[\(coordinates[0]):\(coordinates[1]):\(coordinates[2])]"
            }
            planetControlView.leftButton.isEnabled = true
            planetControlView.leftButton.setTitle("\(planetName)\n\(editedCoordinates)", for: .normal)
            planetControlView.leftButton.setTitleColor(.white, for: .normal)
            planetControlView.leftButton.titleLabel?.textAlignment = .center
            
        default:
            break
        }
    }
    
    // MARK: - Prepare For Segue
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
        }
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
        
        var vc = UIViewController()
        switch indexPath.row {
        case 0:
            vc = OverviewVC(player: player)
        case 6:
            vc = FleetVC(player: player)
        case 7:
            vc = MovementVC(player: player)
        case 8:
            vc = GalaxyVC(player: player)
        default:
            performSegue(withIdentifier: "ShowBuildingVC", sender: indexPath.row)
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - MenuViewDelegate
extension MenuVC: MenuViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            tableViewWithRefresh.tableView.isUserInteractionEnabled = false
            planetControlView.leftButton.isEnabled = false
            planetControlView.rightButton.isEnabled = false
        } else {
            tableViewWithRefresh.tableView.isUserInteractionEnabled = true
            planetControlView.leftButton.isEnabled = true
            planetControlView.rightButton.isEnabled = true
            tableViewWithRefresh.refreshControl.endRefreshing()
        }
    }
    
    func planetIsChanged(for player: PlayerData) {
        self.player = player
        configurePlanetControlView(with: player)
        refreshResourcesTopBarView(with: player)
    }
    
    func refreshResourcesTopBarView(with player: PlayerData?) {
        if let player = player {
            resourcesTopBarView.refresh(player)
        } else {
            resourcesTopBarView.refresh(self.player)
        }
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}
