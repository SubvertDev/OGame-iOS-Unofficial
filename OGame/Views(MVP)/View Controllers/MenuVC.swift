//
//  MenuVC.swift
//  OGame
//
//  Created by Subvert on 3/27/22.
//

import UIKit

protocol IMenuView: AnyObject {
    func showPlanetLoading(_: Bool)
    func showResourcesLoading(_: Bool)
    func planetIsChanged(for: PlayerData)
    func updateResources(with: Resources)
}

final class MenuVC: UIViewController {
    
    private let planetControlView = PlanetControlView()
    private let resourcesBarView = ResourcesTopBarView()
    private let menuTableView = MenuTableView()
    
    private var presenter: MenuPresenter!
    private var player: PlayerData
    private var resources: Resources
    
    private let menuList = ["Overview", "Resources", "Facilities",
                            "Research", "Shipyard", "Defence",
                            "Fleet", "Movement", "Galaxy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Menu"
        
        addSubviews()
        makeConstraints()
        
        planetControlView.delegate = self
        resourcesBarView.delegate = self
        menuTableView.delegate = self
        menuTableView.tableView.delegate = self
        menuTableView.tableView.dataSource = self
        
        planetControlView.updateView(with: player)
        
        presenter = MenuPresenter(view: self, player: player)
        presenter.viewDidLoad(with: player)
    }
    
    init(player: PlayerData, resources: Resources) {
        self.player = player
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Private
    private func addSubviews() {
        view.addSubview(planetControlView)
        view.addSubview(resourcesBarView)
        view.addSubview(menuTableView)
    }

    private func makeConstraints() {
        planetControlView.translatesAutoresizingMaskIntoConstraints = false
        resourcesBarView.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            planetControlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            planetControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            planetControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            planetControlView.heightAnchor.constraint(equalTo: planetControlView.widthAnchor, multiplier: 1.0/2.5),
            
            resourcesBarView.topAnchor.constraint(equalTo: planetControlView.bottomAnchor),
            resourcesBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: resourcesBarView.widthAnchor, multiplier: 1.0/5.0),
            
            menuTableView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Menu View Delegate
extension MenuVC: IMenuView {
    func showPlanetLoading(_ state: Bool) {
        if state {
            planetControlView.leftButton.isEnabled = false
            planetControlView.rightButton.isEnabled = false
            menuTableView.tableView.isUserInteractionEnabled = false
        } else {
            planetControlView.leftButton.isEnabled = true
            planetControlView.rightButton.isEnabled = true
            menuTableView.tableView.isUserInteractionEnabled = true
            menuTableView.refreshControl.endRefreshing()
        }
    }
    
    func showResourcesLoading(_ state: Bool) {
        if state {
            resourcesBarView.alpha = 0.5
            resourcesBarView.activityIndicator.startAnimating()
        } else {
            resourcesBarView.alpha = 1
            resourcesBarView.activityIndicator.stopAnimating()
        }
    }
    
    func planetIsChanged(for player: PlayerData) {
        self.player = player
        planetControlView.updateView(with: self.player)
        presenter.loadResources(for: player)
    }
    
    func updateResources(with resources: Resources) {
        resourcesBarView.updateNew(with: resources)
    }
}

// MARK: - Planet Control View Delegate
extension MenuVC: IPlanetControlView {
    func previousPlanetButtonTapped() {
        presenter.previousPlanetButtonTapped(for: player)
    }
    
    func nextPlanetButtonTapped() {
        presenter.nextPlanetButtonTapped(for: player)
    }
    
    func planetButtonTapped() {
        presenter.planetButtonTapped(for: player)
    }
    
    func moonButtonTapped() {
        presenter.moonButtonTapped(for: player)
    }
}

// MARK: - Resources Bar Delegate
extension MenuVC: IResourcesTopBarView {
    func refreshFinished() {
        
    }
    
    func didGetError(error: OGError) {
        
    }
}

// MARK: - Menu Table View Delegate
extension MenuVC: IMenuTableView {
    func refreshCalled() {
        presenter.loadResources(for: player)
    }
}

// MARK: TableView Delegate & DataSource
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
        
        var vc: UIViewController
        switch indexPath.row {
        case 0:
            vc = OverviewVC(player: player)
        case 1...5:
            vc = BuildingVC(player: player,
                            buildType: BuildingType(rawValue: indexPath.row)!,
                            resources: resources) // todo fix unwraps
        case 6:
            vc = FleetVC(player: player)
        case 7:
            vc = MovementVC(player: player)
        case 8:
            vc = GalaxyVC(player: player)
        default:
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
