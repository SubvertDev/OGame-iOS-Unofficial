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
    
    private var serverListPresenter: ServerListPresenter!
    private var player: PlayerData?
    private var resources: Resources?
    var servers: [MyServer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        serverListPresenter = ServerListPresenter(view: self)
        configureTableView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layer.borderColor = UIColor.label.cgColor
    }

    // MARK: - Configure UI
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
        tableView.rowHeight = 80
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.label.cgColor
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let player = player, let resources = resources else { return }
        if segue.identifier == "ShowMenuVC" {
            let menuVC = segue.destination as! MenuVC
            menuVC.player = player
            menuVC.resources = resources
        }
    }
}

// MARK: - TableView Delegate & Data
extension ServerListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let servers = servers else { return 0 }
        return servers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let servers = servers else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath) as! ServerCell
        cell.serverName.text = servers[indexPath.row].serverName
        cell.playerName.text = servers[indexPath.row].accountName
        cell.language.text = servers[indexPath.row].language.uppercased()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let servers = servers else { return }
        serverListPresenter.enterServer(servers[indexPath.row])
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
        self.player = player
        self.resources = resources
        performSegue(withIdentifier: "ShowMenuVC", sender: self)
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}
