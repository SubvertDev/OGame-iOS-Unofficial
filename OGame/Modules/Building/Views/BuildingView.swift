//
//  BuildingView.swift
//  OGame
//
//  Created by Subvert on 3/25/22.
//

import UIKit

final class BuildingView: UIView {
    
    private let resourcesBar: ResourcesTopBarView = {
        let resourcesBar = ResourcesTopBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    let customTableView: BuildingTableView = {
        let tableView = BuildingTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configureResourcesBar(resources: Resources) {
        resourcesBar.updateNew(with: resources)
    }
    
    // todo move player load resources logic to presenter
//    func updateResourcesBar(player: PlayerData) {
//        resourcesBar.updateNew(for: player)
//    }
    
    func showLoading() {
        customTableView.showLoading()
    }
    
    func showLoaded() {
        customTableView.stopLoading()
        customTableView.tableView.reloadData()
    }
    
    func stopRefreshing() {
        customTableView.refreshControl.endRefreshing()
    }
    
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        customTableView.tableView.delegate = delegate
        customTableView.tableView.dataSource = delegate
    }
    
    // MARK: - Private
    private func addSubviews() {
        addSubview(resourcesBar)
        addSubview(customTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/5.0),
            
            customTableView.topAnchor.constraint(equalTo: resourcesBar.bottomAnchor),
            customTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
