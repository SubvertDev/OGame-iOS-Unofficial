//
//  FleetVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

class MovementVC: UIViewController {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    let fleetLabel = UILabel()

    var fleets: [Fleets]?


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movement"

        configureTableView()
        configureActivityIndicator()
        configureLabel()

        refresh()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FleetCell", bundle: nil), forCellReuseIdentifier: "FleetCell")
        tableView.removeExtraCellLines()
        tableView.alpha = 0.5
        tableView.rowHeight = 100
        tableView.keyboardDismissMode = .onDrag

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])

        activityIndicator.startAnimating()
    }
    
    func configureLabel() {
        view.addSubview(fleetLabel)
        fleetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fleetLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            fleetLabel.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            fleetLabel.topAnchor.constraint(equalTo: tableView.topAnchor),
            fleetLabel.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        
        fleetLabel.text = "No fleet movement at the moment"
        fleetLabel.textAlignment = .center
        fleetLabel.isHidden = true
    }

    @objc func refresh() {
        tableView.alpha = 0.5
        NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
        
        Task {
            do {
                fleets = try await OGame.shared.getFleet()
                
                tableView.reloadData()
                tableView.alpha = 1
                fleetLabel.isHidden = !fleets!.isEmpty
                refreshControl.endRefreshing()
                activityIndicator.stopAnimating()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}

extension MovementVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fleets = fleets {
            return fleets.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fleets = fleets else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FleetCell", for: indexPath) as! FleetCell
        cell.set(with: fleets[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
