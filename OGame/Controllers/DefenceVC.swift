//
//  DefenceVC.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

class DefenceVC: UIViewController {
    
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var player: PlayerData?
    var buildingsDataModel: [BuildingWithAmount]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Defence"

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
    }

    // MARK: - Refresh UI
    @objc func refresh() {
        guard let player = player else { return }
        
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
        
        Task {
            do {
                buildingsDataModel = try await OGDefence.getDefencesWith(playerData: player)
                
                tableView.reloadData()
                refreshControl.endRefreshing()
                tableView.isUserInteractionEnabled = true
                tableView.alpha = 1
                activityIndicator.stopAnimating()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}

// MARK: - Delegate & DataSource
extension DefenceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildingsDataModel = self.buildingsDataModel else { return UITableViewCell() }
        guard let player = player else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.buildButton.tag = indexPath.row
        cell.setShip(building: buildingsDataModel[indexPath.row], playerData: player)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Building Delegate
extension DefenceVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String), _ sender: UIButton) {
        guard let player = player else { return }
        
        let buildingInfo = buildingsDataModel![sender.tag]

        let alertAmount = UIAlertController(title: "\(buildingInfo.name)", message: "Enter an amount for construction", preferredStyle: .alert)
        alertAmount.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        alertAmount.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertAmount.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let ships = Int(alertAmount.textFields![0].text!) ?? 1

            let alert = UIAlertController(title: "Construct \(buildingInfo.name)?", message: "\(ships) defences will be constructed (\(buildingInfo.amount) available)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                self.tableView.isUserInteractionEnabled = false
                self.tableView.alpha = 0.5
                self.activityIndicator.startAnimating()

                let typeToBuild = (type.0, ships, type.2)

                Task {
                    do {
                        try await OGBuild().build(what: typeToBuild, playerData: player)
                        self.refresh()
                    } catch {
                        self.logoutAndShowError(error as! OGError)
                    }
                }
            })
            self.present(alert, animated: true)
        })
        present(alertAmount, animated: true)
    }
}
