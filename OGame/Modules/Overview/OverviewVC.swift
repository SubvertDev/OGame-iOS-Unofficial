//
//  OverviewVC.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import UIKit

protocol IOverviewView: AnyObject {
    func showResourcesLoading(_ state: Bool)
    func updateResourcesBar(with: Resources)
    func showInfoLoading(_ state: Bool)
    func updateTableView(with: [Overview?])
    func showAlert(error: Error)
}

final class OverviewVC: UIViewController {

    // MARK: Properties
    private var player: PlayerData
    private var resources: Resources
    private var overviewInfo: [Overview?]?
    private var presenter: IOverviewPresenter!
    
    var myView: OverviewView { return view as! OverviewView }
    
    // MARK: View Lifecycle
    override func loadView() {
        view = OverviewView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Overview.title
        configureView()
        presenter = OverviewPresenter(view: self)
        presenter.getOverviewInfo(for: player)
    }

    init(player: PlayerData, resources: Resources) {
        self.player = player
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func configureView() {
        myView.updateResourcesBar(with: resources)
        myView.setDelegates(self)
    }
}

// MARK: - Overview View Delegate
extension OverviewVC: IOverviewView {
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResourcesBar(with resources: Resources) {
        myView.updateResourcesBar(with: resources)
    }
    
    func showInfoLoading(_ state: Bool) {
        myView.showInfoLoading(state)
    }
    
    func updateTableView(with overview: [Overview?]) {
        overviewInfo = overview
        myView.updateTableView()
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}

extension OverviewVC: IOverviewInfoView {
    func refreshCalled() {
        presenter.loadResources(for: player)
        presenter.getOverviewInfo(for: player)
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
            return K.Overview.Section.resourcesAndFacilities
        case 1:
            return K.Overview.Section.researches
        case 2:
            return K.Overview.Section.shipyardAndDefences
        default:
            return K.Overview.Section.error
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.overviewCell, for: indexPath) as! OverviewCell

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
