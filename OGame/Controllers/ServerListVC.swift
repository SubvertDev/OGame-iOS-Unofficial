//
//  ServerListVC.swift
//  OGame
//
//  Created by Subvert on 23.07.2021.
//

import UIKit

class ServerListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        OGame.shared.reset()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ServerListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OGame.shared.serversOnAccount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServerCell", for: indexPath)
        cell.textLabel?.text = "\(OGame.shared.serversOnAccount[indexPath.row].serverName)"
        cell.detailTextLabel?.text = "\(OGame.shared.serversOnAccount[indexPath.row].accountName)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isUserInteractionEnabled = false

        OGame.shared.loginIntoSever(with: OGame.shared.serversOnAccount[indexPath.row]) { result in

            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "ShowMenuVC", sender: self)
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }

            tableView.isUserInteractionEnabled = true
        }
    }
}
