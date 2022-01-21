//
//  FleetVCViewController.swift
//  OGame
//
//  Created by Subvert on 13.01.2022.
//

import UIKit

class FleetVC: UIViewController {
    
    let tableView = UITableView()
    let nextButton = UIButton()
    let separator = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    var player: PlayerData?
    var buildingsDataModel: [BuildingWithAmount]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fleet"
                
        configureNextButton()
        configureSeparator()
        configureTableView()
        configureActivityIndicator()

        refresh()
    }
    
    // MARK: - Configure UI
    func configureNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    func configureSeparator() {
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.topAnchor.constraint(equalTo: nextButton.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        separator.backgroundColor = .opaqueSeparator
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SendFleetCell", bundle: nil), forCellReuseIdentifier: "SendFleetCell")
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
    
    // MARK: - Button Pressed
    @objc func nextButtonPressed() {
        if let parent = self.parent as? GenericVC {
            parent.removeChildVC()
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let childViewController = storyboard.instantiateViewController(withIdentifier: "sendFleetVC") as? SendFleetVC
            parent.childVC = childViewController
            parent.configureChildVC()
            childViewController!.player = player
            childViewController!.ships = buildingsDataModel
        }
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
                buildingsDataModel = try await OGShipyard.getShipsWith(playerData: player)
                
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
extension FleetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildingsDataModel = self.buildingsDataModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "SendFleetCell", for: indexPath) as! SendFleetCell
        //cell.delegate = self
        //cell.buildButton.tag = indexPath.row
        cell.setShip(with: buildingsDataModel[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
