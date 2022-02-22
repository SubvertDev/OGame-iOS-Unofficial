//
//  ServerListVC.swift
//  OGame
//
//  Created by Subvert on 23.07.2021.
//

import UIKit

class ServerListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var servers: [MyServer]?
    var playerData: PlayerData?
    var resources: Resources?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        configureTableView()
    }

    // MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
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
}

// MARK: - Delegate & DataSource
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
        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        activityIndicator.startAnimating()

        Task {
            do {
                guard let servers = servers else { throw OGError() }
                
                let serverData = try await AuthServer.loginIntoServerWith(serverInfo: servers[indexPath.row])
                playerData = try await ConfigurePlayer.configurePlayerDataWith(serverData: serverData)
                resources = try await OGResources.getResourcesWith(playerData: playerData!)
                
                tableView.alpha = 1
                tableView.isUserInteractionEnabled = true
                activityIndicator.stopAnimating()
                
                performSegue(withIdentifier: "ShowMenuVC", sender: self)
                
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMenuVC" {
            let menuVC = segue.destination as! MenuVC
            menuVC.player = playerData!
            menuVC.resources = resources!
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layer.borderColor = UIColor.label.cgColor
    }
}
