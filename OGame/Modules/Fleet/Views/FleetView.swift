//
//  FleetView.swift
//  OGame
//
//  Created by Subvert on 3/29/22.
//

import UIKit

final class FleetView: UIView {
    
    private let resourcesBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    let fleetPageButtonsView: FleetPageButtonsView = {
        let fleetPageButtons = FleetPageButtonsView()
        fleetPageButtons.translatesAutoresizingMaskIntoConstraints = false
        return fleetPageButtons
    }()
    
    let genericTableView: GenericTableView = {
        let tableView = GenericTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource
                                  & IFleetPageButtonsView & IGenericTableView) {
        genericTableView.delegate = delegate
        genericTableView.tableView.delegate = delegate
        genericTableView.tableView.dataSource = delegate
        fleetPageButtonsView.delegate = delegate
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
    
    func showTableViewLoading(_ state: Bool) {
        if state {
            genericTableView.tableView.alpha = 0.5
            genericTableView.tableView.isUserInteractionEnabled = false
            genericTableView.activityIndicator.startAnimating()
        } else {
            genericTableView.tableView.alpha = 1
            genericTableView.tableView.isUserInteractionEnabled = true
            genericTableView.activityIndicator.stopAnimating()
            genericTableView.refreshControl.endRefreshing()
        }
    }
    
    func updateTableView() {
        genericTableView.tableView.reloadData()
    }
    
    func updateResources(with resources: Resources) {
        resourcesBarView.updateNew(with: resources)
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(resourcesBarView)
        addSubview(fleetPageButtonsView)
        addSubview(genericTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: resourcesBarView.widthAnchor, multiplier: 1.0/5.0),
            
            fleetPageButtonsView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            fleetPageButtonsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fleetPageButtonsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            genericTableView.topAnchor.constraint(equalTo: fleetPageButtonsView.bottomAnchor),
            genericTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            genericTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            genericTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
