//
//  OverviewVC.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import UIKit

class OverviewVC: UIViewController {
    
    let overviewTotalView = OverviewTotalView()

    var player: PlayerData
    var resources: Resources?
    var overviewInfo: [Overview?]?
    
    
    override func loadView() {
        view = overviewTotalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewTotalView.resourcesTopBarView.configureWith(resources: resources, player: player)

        overviewTotalView.overviewInfoView.tableView.delegate = self
        overviewTotalView.overviewInfoView.tableView.dataSource = self
        overviewTotalView.overviewInfoView.refreshCompletion = { [weak self] in
            self?.overviewTotalView.resourcesTopBarView.refresh(self?.player)
            self?.refresh()
        }
        
        refresh()
    }
    
    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Refresh UI
    func refresh() {
        Task {
            do {
                overviewTotalView.overviewInfoView.startUpdatingUI()
                overviewInfo = try await OGOverview.getOverviewWith(playerData: player)
                overviewTotalView.overviewInfoView.stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
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
