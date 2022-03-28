//
//  OverviewView.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

final class OverviewView: UIView {

    private let resourcesTopBarView: ResourcesBarView = {
        let resourcesBar = ResourcesBarView()
        resourcesBar.translatesAutoresizingMaskIntoConstraints = false
        return resourcesBar
    }()
    
    private let overviewInfoView: OverviewInfoView = {
        let overviewInfo = OverviewInfoView()
        overviewInfo.translatesAutoresizingMaskIntoConstraints = false
        return overviewInfo
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
            resourcesTopBarView.alpha = 0.5
            resourcesTopBarView.activityIndicator.startAnimating()
        } else {
            resourcesTopBarView.alpha = 1
            resourcesTopBarView.activityIndicator.stopAnimating()
        }
    }
    
    func updateResourcesBar(with resources: Resources) {
        resourcesTopBarView.updateNew(with: resources)
    }
    
    func showInfoLoading(_ state: Bool) {
        if state {
            overviewInfoView.tableView.alpha = 0.5
            overviewInfoView.tableView.isUserInteractionEnabled = false
            overviewInfoView.activityIndicator.startAnimating()
        } else {
            overviewInfoView.tableView.alpha = 1
            overviewInfoView.tableView.isUserInteractionEnabled = true
            overviewInfoView.activityIndicator.stopAnimating()
            overviewInfoView.refreshControl.endRefreshing()
        }
    }
    
    func updateTableView() {
        overviewInfoView.tableView.reloadData()
    }
    
    func setDelegates(_ delegate: UITableViewDelegate &
                                  UITableViewDataSource &
                                  IOverviewInfoView) {
        overviewInfoView.delegate = delegate
        overviewInfoView.tableView.delegate = delegate
        overviewInfoView.tableView.dataSource = delegate
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(resourcesTopBarView)
        addSubview(overviewInfoView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            resourcesTopBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesTopBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesTopBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesTopBarView.heightAnchor.constraint(equalTo: resourcesTopBarView.widthAnchor, multiplier: 0.2),
            
            overviewInfoView.topAnchor.constraint(equalTo: resourcesTopBarView.bottomAnchor),
            overviewInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overviewInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
