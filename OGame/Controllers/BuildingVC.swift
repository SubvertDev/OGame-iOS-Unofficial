//
//  BuildingVC.swift
//  OGame
//
//  Created by Subvert on 29.01.2022.
//

import UIKit

class BuildingVC: UIViewController {
    
    @IBOutlet weak var resourcesTopBarView: ResourcesTopBarView!
    @IBOutlet weak var buildingTableView: BuildingTableView!
        
    var resources: Resources?
    var player: PlayerData?
    var buildType: BuildingType?
    var buildings: [Building]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureResourcesTopBarView()
        configureBuildingTableView()
    }
    
    func configureResourcesTopBarView() {
        resourcesTopBarView.configureWith(resources: resources, player: player)
        resourcesTopBarView.refreshFinished = { [weak self] in
            self?.buildingTableView.refreshControl.endRefreshing()
        }
        resourcesTopBarView.didGetError = { [weak self] error in
            self?.logoutAndShowError(error)
        }
        
    }
    
    func configureBuildingTableView() {
        buildingTableView.tableView.delegate = self
        buildingTableView.tableView.dataSource = self
        buildingTableView.refreshCompletion = { [weak self] in
            self?.resourcesTopBarView.refresh(self?.player)
            self?.refresh()
        }
        buildingTableView.startUpdatingUI()
        refresh()
    }
    
    // MARK: - Refresh TableView
    func refresh() {
        Task {
            do {
                guard let player = player else { return }
                switch buildType {
                case .supply:
                    buildings = try await OGSupplies.getSuppliesWith(playerData: player)
                case .facility:
                    buildings = try await OGFacilities.getFacilitiesWith(playerData: player)
                case .research:
                    buildings = try await OGResearch.getResearchesWith(playerData: player)
                case .shipyard:
                    buildings = try await OGShipyard.getShipsWith(playerData: player)
                case .defence:
                    buildings = try await OGDefence.getDefencesWith(playerData: player)
                default:
                    logoutAndShowError(OGError(message: "Build type error", detailed: "Can't load cell data"))
                }
                buildingTableView.stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}

// MARK: - DataSource & Delegate
extension BuildingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildings = buildings, let player = player, let buildType = buildType else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.buildButton.tag = indexPath.row
        cell.set(type: buildType, building: buildings[indexPath.row], playerData: player)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Building Cell Delegate
extension BuildingVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String), _ sender: UIButton) {
        guard let player = player, let buildings = buildings else { return }
        
        let buildingInfo = buildings[sender.tag]
        
        switch buildType {
        case .supply, .facility, .research:
            let alert = UIAlertController(title: "Build \(buildingInfo.name)?", message: "It will be upgraded to level \(buildingInfo.levelOrAmount + 1)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default))
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                Task {
                    do {
                        self.buildingTableView.startUpdatingUI()
                        try await OGBuild.build(what: type, playerData: player)
                        self.resourcesTopBarView.refresh(self.player)
                        self.refresh()
                    } catch {
                        self.logoutAndShowError(error as! OGError)
                    }
                }
            })
            present(alert, animated: true)
            
        case .shipyard, .defence:
            let alertAmount = UIAlertController(title: "\(buildingInfo.name)", message: "Enter an amount for construction", preferredStyle: .alert)
            alertAmount.addTextField { textField in
                textField.keyboardType = .numberPad
                textField.textAlignment = .center
            }
            alertAmount.addAction(UIAlertAction(title: "Cancel", style: .default))
            alertAmount.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let amount = Int(alertAmount.textFields![0].text!) ?? 1
                
                var messageType = ""
                switch self.buildType {
                case .shipyard:
                    messageType += "ship(s)"
                case .defence:
                    messageType += "defence(s)"
                default:
                    break
                }
                
                let alert = UIAlertController(title: "Construct \(buildingInfo.name)?", message: "\(amount) \(messageType) will be constructed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default))
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                    self.buildingTableView.startUpdatingUI()
                    let typeToBuild = (type.0, amount, type.2)
                    Task {
                        do {
                            self.buildingTableView.startUpdatingUI()
                            try await OGBuild.build(what: typeToBuild, playerData: player)
                            self.resourcesTopBarView.refresh(self.player)
                            self.refresh()
                        } catch {
                            self.logoutAndShowError(error as! OGError)
                        }
                    }
                })
                self.present(alert, animated: true)
            })
            present(alertAmount, animated: true)
            
        default:
            logoutAndShowError(OGError(message: "Building error", detailed: "Default case used, check build types"))
        }
    }
}
