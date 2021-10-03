//
//  OverviewVC.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import UIKit

class OverviewVC: UIViewController {
    
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var overviewInfo: [Overview?]?
    let requestGroup = DispatchGroup()

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        tableView.register(UINib(nibName: "OverviewCell", bundle: nil), forCellReuseIdentifier: "OverviewCell")
        tableView.removeExtraCellLines()
        tableView.rowHeight = 88

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
        tableView.isUserInteractionEnabled = false

        OGame.shared.getOverview { result in
            switch result {
            case .success(let data):
                self.overviewInfo = data
                DispatchQueue.main.async {
                    self.tableView.isUserInteractionEnabled = true
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
                }
            case .failure(let error):
                self.logoutAndShowError(error)
            }
        }
    }
}

extension OverviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Resources & Facilities"
        case 1:
            return "Research"
        case 2:
            return "Shipyard & Defences"
        default:
            return "Section error"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell

        switch indexPath.section {
        case 0:
            guard let info = overviewInfo?[0] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .resourcesAndFacilities)
            return cell
        case 1:
            guard let info = overviewInfo?[1] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .researches)
            return cell
        case 2:
            guard let info = overviewInfo?[2] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .shipyardAndDefences)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
