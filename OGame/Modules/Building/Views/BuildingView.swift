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
    
    private let queueBarView: QueueView = {
        let queueBarView = QueueView()
        queueBarView.translatesAutoresizingMaskIntoConstraints = false
        return queueBarView
    }()
    
    private let customTableView: BuildingTableView = {
        let tableView = BuildingTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let adView: AdView = {
       let adView = AdView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    private var queueBarHeightConstraint: NSLayoutConstraint?
    
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
    
    // MARK: - Public
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource
                                  & IBuildingTableView & AdViewDelegate) {
        customTableView.delegate = delegate
        customTableView.tableView.delegate = delegate
        customTableView.tableView.dataSource = delegate
        adView.delegate = delegate
    }
    
    func configureQueueView(buildings: [Building]) {
        queueBarView.setQueue(buildings: buildings)

        queueBarHeightConstraint?.constant = 33
        if !buildings.isEmpty {
            queueBarView.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
            
        } else {
            queueBarHeightConstraint?.constant = 0
            queueBarView.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
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
        addSubview(queueBarView)
        addSubview(customTableView)
        addSubview(adView)
    }
    
    private func makeConstraints() {
        self.queueBarHeightConstraint = NSLayoutConstraint(item: queueBarView, attribute: .height, relatedBy: .equal,
                                                          toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            resourcesBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesBarView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/5.0),
            
            queueBarView.topAnchor.constraint(equalTo: resourcesBarView.bottomAnchor),
            queueBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            queueBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            queueBarHeightConstraint!,
            
            customTableView.topAnchor.constraint(equalTo: queueBarView.bottomAnchor),
            customTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            adView.topAnchor.constraint(equalTo: customTableView.bottomAnchor),
            adView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
