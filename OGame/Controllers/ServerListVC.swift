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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        configureTableView()
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

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

extension ServerListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OGame.shared.serversOnAccount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath) as! ServerCell
        cell.serverName.text = OGame.shared.serversOnAccount[indexPath.row].serverName
        cell.playerName.text = OGame.shared.serversOnAccount[indexPath.row].accountName
        cell.language.text = OGame.shared.serversOnAccount[indexPath.row].language.uppercased()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        activityIndicator.startAnimating()

        Task {
            do {
                try await OGame.shared.loginIntoSever(with: OGame.shared.serversOnAccount[indexPath.row])
                tableView.alpha = 1
                tableView.isUserInteractionEnabled = true
                activityIndicator.stopAnimating()
                performSegue(withIdentifier: "ShowMenuVC", sender: self)
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layer.borderColor = UIColor.label.cgColor
    }
}
