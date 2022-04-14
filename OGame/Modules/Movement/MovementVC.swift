//
//  MovementVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

protocol IMovementView: AnyObject {
    func showResourcesLoading(_ state: Bool)
    func updateResources(with: Resources)
    func showMovementLoading(_ state: Bool)
    func updateMovementTableView(with: [Fleets])
    func showAlert(error: OGError)
}

final class MovementVC: BaseViewController {
    
    // MARK: Properties
    private var player: PlayerData
    private var resources: Resources
    private var fleets: [Fleets]?
    private var presenter: MovementPresenter!
    private var myView: MovementView { return view as! MovementView }
    
    // MARK: View Lifecycle
    override func loadView() {
        view = MovementView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.movement
        
        myView.setDelegates(self)
        myView.updateResources(with: resources)
        
        presenter = MovementPresenter(view: self)
        presenter.loadMovement(for: player)
    }
    
    init(player: PlayerData, resources: Resources) {
        self.player = player
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MovementView Delegate
extension MovementVC: IMovementView {
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResources(with resources: Resources) {
        myView.updateResources(with: resources)
    }
    
    func showMovementLoading(_ state: Bool) {
        myView.showMovementLoading(state)
    }
    
    func updateMovementTableView(with fleets: [Fleets]) {
        self.fleets = fleets
        myView.updateMovementTableView()
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}

extension MovementVC: IGenericTableView {
    func refreshCalled() {
        presenter.loadResources(for: player)
        presenter.loadMovement(for: player)
    }
}

// MARK: - Delegates & DataSource
extension MovementVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fleets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fleets = fleets else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.fleetCell, for: indexPath) as! FleetCell
        cell.set(with: fleets[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
