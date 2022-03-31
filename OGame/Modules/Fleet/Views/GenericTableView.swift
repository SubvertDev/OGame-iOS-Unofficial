//
//  GenericTableView.swift
//  OGame
//
//  Created by Subvert on 02.02.2022.
//

import UIKit

protocol IGenericTableView {
    func refreshCalled()
}

final class GenericTableView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 88
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: K.CellReuseID.sendFleetCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.sendFleetCell)
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCalled), for: .valueChanged)
        return refreshControl
    }()
    
    var delegate: IGenericTableView?
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    // todo delete?
    func registerTableViewCell(withIdentifier identifier: String? = nil) {
        if let identifier = identifier {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
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
