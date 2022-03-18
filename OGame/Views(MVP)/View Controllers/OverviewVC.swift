//
//  OverviewVC.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import UIKit

protocol OverviewViewDelegate: AnyObject {
    func showLoading(_ state: Bool)
    func updateTableView(with: [Overview?])
    func showAlert(error: Error)
}

final class OverviewVC: UIViewController {

    // MARK: - Properties
    private var overviewPresenter: OverviewPresenterDelegate!
    private var player: PlayerData
    private var resources: Resources?
    private var overviewInfo: [Overview?]?
    
    var myView: OverviewView { return view as! OverviewView }
    
    override func loadView() {
        view = OverviewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewPresenter = OverviewPresenter(view: self)
        configureViews()
    }

    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Views
    func configureViews() {
        myView.resourcesTopBarView.configureWith(resources: resources, player: player)
        myView.overviewInfoView.tableView.delegate = self
        myView.overviewInfoView.tableView.dataSource = self
        overviewPresenter.getOverviewInfo(for: player)
    }
    
    @objc func refreshControl() {
        myView.resourcesTopBarView.refresh(player)
        overviewPresenter.getOverviewInfo(for: player)
    }
}

// MARK: - Overview View Delegate
extension OverviewVC: OverviewViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            myView.overviewInfoView.tableView.alpha = 0.5
            myView.overviewInfoView.tableView.isUserInteractionEnabled = false
            myView.overviewInfoView.activityIndicator.startAnimating()
        } else {
            myView.overviewInfoView.tableView.alpha = 1
            myView.overviewInfoView.tableView.isUserInteractionEnabled = true
            myView.overviewInfoView.activityIndicator.stopAnimating()
            myView.overviewInfoView.refreshControl.endRefreshing()
        }
    }
    
    func updateTableView(with overview: [Overview?]) {
        overviewInfo = overview
        myView.overviewInfoView.tableView.reloadData()
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}

// MARK: - Delegate & DataSource
extension OverviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Resources & Facilities"
        case 1:
            return "Research"
        case 2:
            return "Shipyard & Defences"
        default:
            return "Section error"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as! OverviewCell

        switch indexPath.section {
        case 0:
            guard let info = overviewInfo?[0] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .resourcesAndFacilities)
            return cell
        case 1:
            guard let info = overviewInfo?[1] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .researches)
            return cell
        case 2:
            guard let info = overviewInfo?[2] else { return UITableViewCell() }
            cell.set(name: info.buildingName, level: info.upgradeLevel, type: .shipyardAndDefences)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
