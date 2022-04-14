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

final class ServerListVC: BaseViewController {
    
    private let servers: [MyServer]
    private var presenter: ServerListPresenter!
    private var myView: ServerListView { return view as! ServerListView }
    
    // MARK: - View Lifecycle
    override func loadView() {
        view = ServerListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Server List"
        navigationItem.hidesBackButton = true
        
        configureTableView()
        presenter = ServerListPresenter(view: self)
    }
    
    init(servers: [MyServer]) {
        self.servers = servers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        myView.tableView.layer.borderColor = UIColor.label.cgColor
    }
    
    // MARK: - IBActions
    @objc func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Private
    private func configureTableView() {
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        myView.tableView.removeExtraCellLines()
        myView.tableView.rowHeight = 80
        myView.tableView.layer.borderWidth = 2
        myView.tableView.layer.borderColor = UIColor.label.cgColor
        myView.tableView.layer.cornerRadius = 10
        myView.tableView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
    }
}

// MARK: - TableView Delegate & DataSource
extension ServerListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.serverCell, for: indexPath) as! ServerCell
        cell.set(with: servers[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.enterServer(servers[indexPath.row])
    }
}

// MARK: - ServerListViewDelegate
extension ServerListVC: ServerListViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            myView.tableView.alpha = 0.5
            myView.activityIndicator.startAnimating()
            myView.tableView.isUserInteractionEnabled = false
        } else {
            myView.tableView.alpha = 1
            myView.activityIndicator.stopAnimating()
            myView.tableView.isUserInteractionEnabled = true
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
