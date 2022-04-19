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
    
    private var myView: ServerListView { return view as! ServerListView }
    
    private var presenter: ServerListPresenter!
    private let servers: [MyServer]
    
    // MARK: - View Lifecycle
    override func loadView() {
        view = ServerListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        
        presenter = ServerListPresenter(view: self)
    }
    
    init(servers: [MyServer]) {
        self.servers = servers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myView.gradient.frame = myView.embedView.bounds
    }
    
    // MARK: - IBActions
    @objc func logoutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - ServerListViewDelegate
extension ServerListVC: ServerListViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            myView.tableView.alpha = 0.5
            myView.activityIndicator.startAnimating()
            myView.tableView.isUserInteractionEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            myView.tableView.alpha = 1
            myView.activityIndicator.stopAnimating()
            myView.tableView.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func performLogin(player: PlayerData, resources: Resources) {
        let vc = MenuVC(player: player, resources: resources)
        if let banner = player.banner, !K.debugMode {
            showAd(in: self, banner: banner) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
    
    @objc func adButtonPressed(_ sender: UIButton) {
        guard let link = sender.layer.name else { return }
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CustomHeader()
    }
}
