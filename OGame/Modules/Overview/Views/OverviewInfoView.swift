//
//  OverviewInfoView.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

protocol IOverviewInfoView {
    func refreshCalled()
}

final class OverviewInfoView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 88
        tableView.register(UINib(nibName: K.CellReuseID.overviewCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.overviewCell)
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshCalled), for: .valueChanged)
        return refresh
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    var delegate: IOverviewInfoView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private
    private func addSubviews() {
        addSubview(tableView)
        tableView.refreshControl = refreshControl
        addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func refreshCalled() {
        delegate?.refreshCalled()
    }
}
