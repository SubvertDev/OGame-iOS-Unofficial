//
//  BuildingVC.swift
//  OGame
//
//  Created by Subvert on 29.01.2022.
//

import UIKit

protocol IBuildingView: AnyObject {
    func showResourcesLoading(_ state: Bool)
    func updateResourcesBar(with: Resources)
    func showBuildingsLoading(_ state: Bool)
    func updateBuildings(_ buildings: [Building])
    func showAlert(error: OGError)
}

final class BuildingVC: UIViewController {
    
    // MARK: Properties
    private var presenter: BuildingPresenter!
    private var player: PlayerData
    private var resources: Resources
    private var buildType: BuildingType
    private var buildings: [Building]?
    
    private var myView: BuildingView { return view as! BuildingView }

    // MARK: View Lifecycle
    override func loadView() {
        view = BuildingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Menu.cellTitlesList[buildType.rawValue]
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
    
    // MARK: Private
    private func configureViews() {
        myView.setDelegates(self)
        myView.updateResourcesBar(with: resources)
    }
}

// MARK: - Building View Delegate
extension BuildingVC: IBuildingView {
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResourcesBar(with resources: Resources) {
        myView.updateResourcesBar(with: resources)
    }
    
    func showBuildingsLoading(_ state: Bool) {
        myView.showBuildingsLoading(state)
    }
    
    func updateBuildings(_ buildings: [Building]) {
        self.buildings = buildings
        myView.updateBuildings()
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}

extension BuildingVC: IBuildingTableView {
    func refreshCalled() {
        presenter.loadResources(for: player)
        presenter.loadBuildings(for: player, with: buildType)
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
        cell.set(type: buildType, building: buildings[indexPath.row], player: player)

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
        case .supplies, .facilities, .research:
            let alert = UIAlertController(title: "Build \(buildingInfo.name)?", message: "It will be upgraded to level \(buildingInfo.levelOrAmount + 1)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: K.Error.no, style: .default))
            alert.addAction(UIAlertAction(title: K.Error.yes, style: .default) { _ in
                Task {
                    do {
                        self.myView.showResourcesLoading(true)
                        self.myView.showBuildingsLoading(true)
                        try await BuildProvider.build(what: type, playerData: self.player)
                        self.presenter.loadResources(for: self.player)
                        self.presenter.loadBuildings(for: self.player, with: self.buildType)
                    } catch {
                        self.logoutAndShowError(error as! OGError)
                    }
                }
            })
            present(alert, animated: true)
            
        case .shipyard, .defenses:
            let alertAmount = UIAlertController(title: "\(buildingInfo.name)", message: "Enter an amount for construction", preferredStyle: .alert)
            alertAmount.addTextField { textField in
                textField.keyboardType = .numberPad
                textField.textAlignment = .center
            }
            alertAmount.addAction(UIAlertAction(title: K.Error.cancel, style: .default))
            alertAmount.addAction(UIAlertAction(title: K.Error.ok, style: .default) { _ in
                let amount = Int(alertAmount.textFields![0].text!) ?? 1
                
                var messageType = ""
                switch self.buildType {
                case .shipyard:
                    messageType += "ship(s)"
                case .defenses:
                    messageType += "defence(s)"
                default:
                    break
                }
                
                let alert = UIAlertController(title: "Construct \(buildingInfo.name)?", message: "\(amount) \(messageType) will be constructed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: K.Error.no, style: .default))
                alert.addAction(UIAlertAction(title: K.Error.yes, style: .default) { _ in
                    let typeToBuild = (type.0, amount, type.2)
                    Task {
                        do {
                            self.myView.showResourcesLoading(true)
                            self.myView.showBuildingsLoading(true)
                            try await BuildProvider.build(what: typeToBuild, playerData: self.player)
                            self.presenter.loadResources(for: self.player)
                            self.presenter.loadBuildings(for: self.player, with: self.buildType)
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
