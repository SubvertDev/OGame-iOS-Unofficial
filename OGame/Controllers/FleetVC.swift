//
//  FleetVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

class FleetVC: UIViewController {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var fleets: [Fleets]?


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fleet"

        configureTableView()
        configureActivityIndicator()

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

    @objc func refresh() {
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
        NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
        
        OGame.shared.getFleet { result in
            switch result {
            case .success(let fleets):
                self.fleets = fleets
                for fleet in fleets { print(fleet) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.alpha = 1
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                self.logoutAndShowError(error)
            }
        }
    }
}

extension FleetVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
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
