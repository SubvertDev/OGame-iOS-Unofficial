//
//  MenuVC.swift
//  OGame
//
//  Created by Subvert on 3/27/22.
//

import UIKit

protocol IMenuView: AnyObject {
    func showPlanetLoading(_: Bool)
    func planetIsChanged(for: PlayerData)
    func showResourcesLoading(_: Bool)
    func updateResources(with: Resources)
    func showAlert(error: OGError)
}

final class MenuVC: UIViewController {
    
    // MARK: - Properties
    private var presenter: MenuPresenter!
    private var player: PlayerData
    private var resources: Resources
    private let menuList = K.Menu.cellTitlesList
    private var isFirstLoad = true
    
    private var myView: MenuView { return view as! MenuView }

    // MARK: - View Lifecycle
    override func loadView() {
        view = MenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = K.Menu.title
        
        configureView()
        presenter = MenuPresenter(view: self, player: player)
        presenter.viewDidLoad(with: player)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstLoad {
            presenter.loadResources(for: player)
        }
        isFirstLoad = false
    }
    
    init(player: PlayerData, resources: Resources) {
        self.player = player
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configureView() {
        myView.setDelegates(self)
        myView.updateControlView(with: player)
    }
}

// MARK: - Menu View Delegate
extension MenuVC: IMenuView {
    func showPlanetLoading(_ state: Bool) {
        myView.showPlanetLoading(state)
    }
    
    func planetIsChanged(for player: PlayerData) {
        self.player = player
        myView.updateControlView(with: player)
        presenter.loadResources(for: player)
    }
    
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResources(with resources: Resources) {
        myView.updateResourcesBar(with: resources)
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
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

// MARK: - Menu TableView Delegate
extension MenuVC: IMenuTableView {
    func refreshCalled() {
        presenter.loadResources(for: player)
    }
}

// MARK: - TableView Delegate & DataSource
extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.menuCell, for: indexPath) as! MenuCell
        cell.set(with: menuList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc: UIViewController
        let resources = myView.getCurrentResources()
        switch indexPath.row {
        case 0:
            vc = OverviewVC(player: player, resources: resources)
        case 1...5:
            let buildType = BuildingType(rawValue: indexPath.row)!
            vc = BuildingVC(player: player,
                            buildType: buildType,
                            resources: resources)
        case 6:
            vc = FleetVC(player: player, resources: resources)
        case 7:
            vc = MovementVC(player: player, resources: resources)
        case 8:
            vc = GalaxyVC(player: player)
        default:
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
