//
//  BuildingView.swift
//  OGame
//
//  Created by Subvert on 3/25/22.
//

import UIKit

final class BuildingView: UIView {
    
    private let resourcesBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    private let customTableView: BuildingTableView = {
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
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource & IBuildingTableView) {
        customTableView.delegate = delegate
        customTableView.tableView.delegate = delegate
        customTableView.tableView.dataSource = delegate
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
    
    func updateResourcesBar(with resources: Resources) {
        resourcesBarView.updateNew(with: resources)
    }

    func showBuildingsLoading(_ state: Bool) {
        if state {
            customTableView.alpha = 0.5
            customTableView.isUserInteractionEnabled = false
            customTableView.activityIndicator.startAnimating()
        } else {
            customTableView.alpha = 1
            customTableView.isUserInteractionEnabled = true
            customTableView.activityIndicator.stopAnimating()
            customTableView.refreshControl.endRefreshing()
        }
    }
    
    func updateBuildings() {
        customTableView.tableView.reloadData()
    }
    
    func stopRefreshing() {
        customTableView.refreshControl.endRefreshing()
    }
    
    // MARK: - Private
    private func addSubviews() {
        addSubview(resourcesBarView)
        addSubview(customTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/5.0),
            
            customTableView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            customTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
