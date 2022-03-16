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
}

final class MenuVC: UIViewController {
        
    @IBOutlet weak var planetControlView: PlanetControlView!
    @IBOutlet weak var resourcesTopBarView: ResourcesTopBarView!
    @IBOutlet weak var tableViewWithRefresh: MenuTableView!
    
    private var menuPresenter: MenuPresenter!
    
    var timer: Timer?
    var resources: Resources?
    var prodPerSecond: [Double]?
    var player: PlayerData?
    
    let menuList = ["Overview", "Resources", "Facilities",
                    "Research", "Shipyard", "Defence",
                    "Fleet", "Movement", "Galaxy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        menuPresenter = MenuPresenter(view: self)
        configurePlanetControlView()
        configureResourcesTopBarView()
        configureTableViewWithRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resourcesTopBarView.configureWith(resources: nil, player: player)
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

extension MenuVC: MenuViewDelegate {
    func showLoading(_ state: Bool) {
        
    }
    
    func showAlert(error: Error) {
        
    }
}
