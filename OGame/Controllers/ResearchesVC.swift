//
//  ResearchVC.swift
//  OGame
//
//  Created by Subvert on 26.05.2021.
//

import UIKit

class ResearchVC: UIViewController {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var player: PlayerData?
    var buildingsDataModel: [BuildingWithLevel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Research"

        configureTableView()
        configureActivityIndicator()

        refresh()
    }

    // MARK: - Configure UI
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
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        tableView.removeExtraCellLines()
        tableView.alpha = 0.5
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
    }

    // MARK: - Refresh UI
    @objc func refresh() {
        Task {
            do {
                guard let player = player else { return }
                startUpdatingUI()
                buildingsDataModel = try await OGResearch.getResearchesWith(playerData: player)
                stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    func startUpdatingUI() {
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
    }
    
    func stopUpdatingUI() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        tableView.isUserInteractionEnabled = true
        tableView.alpha = 1
        activityIndicator.stopAnimating()
    }
}

// MARK: - Delegate & DataSource
extension ResearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildingsDataModel = self.buildingsDataModel else { return UITableViewCell() }
        guard let playerData = player else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.buildButton.tag = indexPath.row
        cell.setResearch(building: buildingsDataModel[indexPath.row], playerData: playerData)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Building Delegate
extension ResearchVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String), _ sender: UIButton) {
        guard let player = player else { return }
        
        let buildingInfo = buildingsDataModel![sender.tag]

        let alert = UIAlertController(title: "Research \(buildingInfo.name)?", message: "It will be researched to level \(buildingInfo.level + 1)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.tableView.isUserInteractionEnabled = false
            self.tableView.alpha = 0.5
            self.activityIndicator.startAnimating()

            Task {
                do {
                    try await OGBuild().build(what: type, playerData: player)
                    self.refresh()
                } catch {
                    self.logoutAndShowError(error as! OGError)
                }
            }
        })
        present(alert, animated: true)
    }
}
