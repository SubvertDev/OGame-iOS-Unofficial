//
//  ServerListVC.swift
//  OGame
//
//  Created by Subvert on 23.07.2021.
//

import UIKit

protocol ServerListViewDelegate: AnyObject {
    func showLoading(_ state: Bool)
    func performLogin(player: PlayerData, resources: Resources)
    func showAlert(error: Error)
}

final class ServerListVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: ServerListPresenter!
    var servers: [MyServer]?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureTableView()
        presenter = ServerListPresenter(view: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layer.borderColor = UIColor.label.cgColor
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Private
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
        tableView.rowHeight = 80
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.label.cgColor
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
    }
}

// MARK: - TableView Delegate & DataSource
extension ServerListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let servers = servers else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.serverCell, for: indexPath) as! ServerCell
        cell.set(with: servers[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let servers = servers else { return }
        presenter.enterServer(servers[indexPath.row])
    }
}

// MARK: - ServerListViewDelegate
extension ServerListVC: ServerListViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            tableView.alpha = 0.5
            activityIndicator.startAnimating()
            tableView.isUserInteractionEnabled = false
        } else {
            tableView.alpha = 1
            activityIndicator.stopAnimating()
            tableView.isUserInteractionEnabled = true
        }
    }
    
    func performLogin(player: PlayerData, resources: Resources) {
        let vc = MenuVC(player: player, resources: resources)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}
