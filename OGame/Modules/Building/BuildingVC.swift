//
//  BuildingVC.swift
//  OGame
//
//  Created by Subvert on 29.01.2022.
//

import UIKit

protocol BuildingViewDelegate: AnyObject {
    func showBuildings(_ buildings: [Building])
    func showError(_ error: OGError)
}

final class BuildingVC: UIViewController {
    
    private var myView: BuildingView { return view as! BuildingView }
    
    private var presenter: BuildingPresenter!
    private var player: PlayerData
    private var resources: Resources
    private var buildType: BuildingType
    private var buildings: [Building]?
    
    override func loadView() {
        view = BuildingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        presenter = BuildingPresenter(view: self)
        presenter.loadBuildings(for: player, with: buildType)
    }
    
    init(player: PlayerData, buildType: BuildingType, resources: Resources) {
        self.player = player
        self.buildType = buildType
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func tableViewRefreshCalled() {
        // todo move logic to presenter
        //myView.updateResourcesBar(player: player)
    }
    
    // MARK: Private
    private func configureViews() {
        myView.configureResourcesBar(resources: resources) // todo fix unwrap
        myView.setDelegates(self)
        myView.showLoading()
    }
}

// MARK: - Building View Delegate
extension BuildingVC: BuildingViewDelegate {
    func showBuildings(_ buildings: [Building]) {
        self.buildings = buildings
        myView.showLoaded()
    }
    
    func showError(_ error: OGError) {
        logoutAndShowError(error)
    }
}

// MARK: - Resources Top Bar View Delegate
extension BuildingVC: IResourcesTopBarView {
    func refreshFinished() {
        myView.stopRefreshing()
    }
    
    func didGetError(error: OGError) {
        logoutAndShowError(error)
    }
}

// MARK: - DataSource & Delegate
extension BuildingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildings = buildings else { return UITableViewCell() }

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
        guard let buildings = buildings else { return }
        
        let buildingInfo = buildings[sender.tag]
        
        switch buildType {
        case .supply, .facility, .research:
            let alert = UIAlertController(title: "Build \(buildingInfo.name)?", message: "It will be upgraded to level \(buildingInfo.levelOrAmount + 1)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default))
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                Task {
                    do {
                        self.myView.showLoading()
                        try await OGBuild.build(what: type, playerData: self.player)
                        // todo move logic to presenter
                        //self.myView.updateResourcesBar(player: self.player)
                        self.myView.showLoaded()
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
                    //self.myView.tableView.startUpdatingUI()
                    let typeToBuild = (type.0, amount, type.2)
                    Task {
                        do {
                            self.myView.showLoading()
                            try await OGBuild.build(what: typeToBuild, playerData: self.player)
                            // todo move logic to presenter
                            //self.myView.updateResourcesBar(player: self.player)
                            self.myView.showLoaded()
                        } catch {
                            self.logoutAndShowError(error as! OGError)
                        }
                    }
                })
                self.present(alert, animated: true)
            })
            present(alertAmount, animated: true)
        }
    }
}
