//
//  OverviewTableView.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

class OverviewInfoView: UIView {

    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    
    var refreshCompletion: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubviews()
    }
    
    func createSubviews() {
        configureTableView()
        configureActivityIndicator()
    }
    
    func configureTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        tableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
        tableView.removeExtraCellLines()
        tableView.alpha = 0.5
        tableView.rowHeight = 88

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func startUpdatingUI() {
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopUpdatingUI() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        tableView.isUserInteractionEnabled = true
        tableView.alpha = 1
        activityIndicator.stopAnimating()
    }
    
    @objc func refresh() {
        refreshCompletion?()
    }
}
