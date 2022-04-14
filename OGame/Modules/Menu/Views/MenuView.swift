//
//  MenuView.swift
//  OGame
//
//  Created by Subvert on 3/28/22.
//

import UIKit

final class MenuView: UIView {
    
    private let planetControlView: PlanetControlView = {
        let planetControl = PlanetControlView()
        planetControl.translatesAutoresizingMaskIntoConstraints = false
        return planetControl
    }()
    
    private let resourcesBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
     let menuTableView: MenuTableView = {
        let menuTable = MenuTableView()
        menuTable.translatesAutoresizingMaskIntoConstraints = false
        return menuTable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource &
                                  IPlanetControlView & IMenuTableView) {
        planetControlView.delegate = delegate
        menuTableView.delegate = delegate
        menuTableView.tableView.delegate = delegate
        menuTableView.tableView.dataSource = delegate
    }
    
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
    
    func updateControlView(with player: PlayerData) {
        planetControlView.updateView(with: player)
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
    
    func getCurrentResources() -> Resources {
        return resourcesBarView.currentResources
    }
    
    func updateResourcesBar(with resources: Resources) {
        resourcesBarView.updateNew(with: resources)
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(planetControlView)
        addSubview(resourcesBarView)
        addSubview(menuTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            planetControlView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            planetControlView.leadingAnchor.constraint(equalTo: leadingAnchor),
            planetControlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            planetControlView.heightAnchor.constraint(equalTo: planetControlView.widthAnchor, multiplier: 1.0/2.5),
            
            resourcesBarView.topAnchor.constraint(equalTo: planetControlView.bottomAnchor),
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: resourcesBarView.widthAnchor, multiplier: 1.0/5.0),
            
            menuTableView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
