//
//  TableViewWithRefresh.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

protocol IMenuTableView {
    func refreshCalled()
}

final class MenuTableView: UIView {
    
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.removeExtraCellLines()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.addTarget(self, action: #selector(refreshCalled), for: .valueChanged)
        return refresh
    }()
    
    var delegate: IMenuTableView?
    
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
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func refreshCalled() {
        delegate?.refreshCalled()
    }
}
