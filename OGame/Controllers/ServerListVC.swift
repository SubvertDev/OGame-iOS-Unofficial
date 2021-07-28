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
        OGame.shared.reset()
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

        OGame.shared.loginIntoSever(with: OGame.shared.serversOnAccount[indexPath.row]) { result in

            switch result {
            case .success(_):
                tableView.alpha = 1
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "ShowMenuVC", sender: self)
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }

            tableView.isUserInteractionEnabled = true
            tableView.alpha = 1
            self.activityIndicator.stopAnimating()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layer.borderColor = UIColor.label.cgColor
    }
}
