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
    @IBOutlet weak var resourcesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    
    let refreshControl = UIRefreshControl()
    
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
        
        guard let player = player else { return }
        if player.celestials.count == 1 {
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        }
                
        configureTableView()
        configureLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
        if let index = player.planetNames.firstIndex(of: player.planet) {
            if index + 1 == player.planetNames.count {
                player.currentPlanetIndex = 0
                player.planet = player.planetNames[0]
                player.planetID = player.planetIDs[0]
            } else {
                player.currentPlanetIndex += 1
                player.planet = player.planetNames[index + 1]
                player.planetID = player.planetIDs[index + 1]
            }
        }
        
        configureLabels()
        refresh()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        guard var player = player else { return }
        
        if let index = player.planetNames.firstIndex(of: player.planet) {
            if index - 1 == -1 {
                player.currentPlanetIndex = player.planetNames.count - 1
                player.planet = player.planetNames.last!
                player.planetID = player.planetIDs.last!
            } else {
                player.currentPlanetIndex -= 1
                player.planet = player.planetNames[index - 1]
                player.planetID = player.planetIDs[index - 1]
            }
        }
        
        configureLabels()
        refresh()
    }
    
    // MARK: - Configure UI
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
    }
    
    func configureLabels() {
        guard let player = player else { return }
        
        planetNameLabel.text = player.planet
        serverNameLabel.text = player.universe
        rankLabel.text = "Rank: \(player.rank)"
        let used = player.celestials[player.currentPlanetIndex].used
        let total = player.celestials[player.currentPlanetIndex].total
        fieldsLabel.text = "\(used)/\(total)"
        let galaxy = player.celestials[player.currentPlanetIndex].coordinates[0]
        let system = player.celestials[player.currentPlanetIndex].coordinates[1]
        let position = player.celestials[player.currentPlanetIndex].coordinates[2]
        coordinatesLabel.text = "[\(galaxy):\(system):\(position)]"
        planetImage.image = player.planetImages[player.currentPlanetIndex]
    }
    
    // MARK: - Refresh UI
    @objc func refresh() {
        guard let player = player else { return }
        
        resourcesOverview.bringSubviewToFront(resourcesActivityIndicator)
        resourcesOverview.alpha = 0.5
        resourcesActivityIndicator.startAnimating()
        refreshControl.endRefreshing()
        
        Task {
            do {
                resources = try await OGResources().getResourcesWith(playerData: player)
                refreshResourcesView(with: resources!)
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    func refreshResourcesView(with resources: Resources) {
        resourcesOverview.set(metal: resources.metal,
                              crystal: resources.crystal,
                              deuterium: resources.deuterium,
                              energy: resources.energy)
        
        var production = [Double]()
        for day in resources.dayProduction {
            let dayDouble = Double(day)
            production.append(dayDouble / 3600)
        }
        prodPerSecond = production
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.resourcesOverview.update(metal: self.prodPerSecond![0],
                                          crystal: self.prodPerSecond![1],
                                          deuterium: self.prodPerSecond![2],
                                          storage: resources)
        }
        RunLoop.main.add(timer!, forMode: .common)
        
        resourcesOverview.alpha = 1
        resourcesActivityIndicator.stopAnimating()
    }
}

// MARK: - Delegate & DataSource
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
        
        if indexPath.row == 8 {
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
                (vc.childVC as! OverviewVC).player = player
                vc.player = player
            case 1:
                vc.childVC = ResourcesVC()
                (vc.childVC as! ResourcesVC).player = player
                vc.player = player
            case 2:
                vc.childVC = FacilitiesVC()
                (vc.childVC as! FacilitiesVC).player = player
                vc.player = player
            case 3:
                vc.childVC = ResearchVC()
                (vc.childVC as! ResearchVC).player = player
                vc.player = player
            case 4:
                vc.childVC = ShipyardVC()
                (vc.childVC as! ShipyardVC).player = player
                vc.player = player
            case 5:
                vc.childVC = DefenceVC()
                (vc.childVC as! DefenceVC).player = player
                vc.player = player
            case 6:
                vc.childVC = FleetVC()
                (vc.childVC as! FleetVC).player = player
                vc.player = player
            case 7:
                vc.childVC = MovementVC()
                (vc.childVC as! MovementVC).player = player
                vc.player = player
            default:
                break
            }
            
            vc.title = menuList[page]
            vc.resources = resources
            vc.prodPerSecond = prodPerSecond
        } else if let vc = segue.destination as? GalaxyVC {
            vc.player = player
        }
    }
}
