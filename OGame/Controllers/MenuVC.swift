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
    
    let menuList = ["Overview",
                    "Resources",
                    "Facilities",
                    "Research",
                    "Shipyard",
                    "Defence",
                    "Fleet (unavailable)",
                    "Movement",
                    "Galaxy"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        
        if OGame.shared.celestials!.count == 1 {
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
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        OGame.shared.setNextPlanet { error in
            if let error = error {
                self.logoutAndShowError(error)
            } else {
                self.configureLabels()
                self.refresh()
            }
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        OGame.shared.setPreviousPlanet { error in
            if let error = error {
                self.logoutAndShowError(error)
            } else {
                self.configureLabels()
                self.refresh()
            }
        }
    }
    
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
        planetNameLabel.text = OGame.shared.planet
        serverNameLabel.text = OGame.shared.universe
        rankLabel.text = "Rank: \(OGame.shared.rank!)"
        fieldsLabel.text = "\(OGame.shared.celestial!.used)/\(OGame.shared.celestial!.total)"
        coordinatesLabel.text = "[\(OGame.shared.celestial!.coordinates[0]):\(OGame.shared.celestial!.coordinates[1]):\(OGame.shared.celestial!.coordinates[2])]"
        planetImage.image = OGame.shared.planetImage
    }
    
    @objc func refresh() {
        resourcesOverview.bringSubviewToFront(resourcesActivityIndicator)
        resourcesOverview.alpha = 0.5
        resourcesActivityIndicator.startAnimating()
        refreshControl.endRefreshing()
        
        Task {
            do {
                resources = try await OGame.shared.getResources()
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
            case 1:
                vc.childVC = ResourcesVC()
            case 2:
                vc.childVC = FacilitiesVC()
            case 3:
                vc.childVC = ResearchVC()
            case 4:
                vc.childVC = ShipyardVC()
            case 5:
                vc.childVC = DefenceVC()
            case 6:
                print("fleet vc")
            case 7:
                vc.childVC = MovementVC()
            case 8:
                vc.childVC = GalaxyVC()
            default:
                print(sender as! Int)
            }
            
            vc.title = menuList[page]
            vc.resources = resources
            vc.prodPerSecond = prodPerSecond
        }
    }
}
