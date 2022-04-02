//
//  SendFleetView.swift
//  OGame
//
//  Created by Subvert on 3/31/22.
//

import UIKit

final class SendFleetView: UIView {
    
    private let resourcesBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: K.CellReuseID.setCoordinatesCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.setCoordinatesCell)
        tableView.register(UINib(nibName: K.CellReuseID.missionTypeCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.missionTypeCell)
        tableView.register(UINib(nibName: K.CellReuseID.missionBriefingCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.missionBriefingCell)
        tableView.register(UINib(nibName: K.CellReuseID.fleetSettingsCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.fleetSettingsCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
    
    func showFleetSendLoading(_ state: Bool) {
        if state {
            tableView.alpha = 0.5
            tableView.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
        } else {
            tableView.alpha = 1
            tableView.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(resourcesBarView)
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: resourcesBarView.widthAnchor, multiplier: 0.2),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

