//
//  MovementView.swift
//  OGame
//
//  Created by Subvert on 4/2/22.
//

import UIKit

final class MovementView: UIView {

    private let resourcesBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    private let genericTableView: GenericTableView = {
        let tableView = GenericTableView()
        tableView.tableView.register(UINib(nibName: K.CellReuseID.fleetCell, bundle: nil),
                                     forCellReuseIdentifier: K.CellReuseID.fleetCell)
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
    
    // MARK: Public
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource & IGenericTableView) {
        genericTableView.delegate = delegate
        genericTableView.tableView.delegate = delegate
        genericTableView.tableView.dataSource = delegate
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
    
    func updateResources(with resources: Resources) {
        resourcesBarView.updateNew(with: resources)
    }
    
    func showMovementLoading(_ state: Bool) {
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
    
    func updateMovementTableView() {
        genericTableView.tableView.reloadData()
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(resourcesBarView)
        addSubview(genericTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: resourcesBarView.widthAnchor, multiplier: 0.2),
            
            genericTableView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            genericTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            genericTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            genericTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
