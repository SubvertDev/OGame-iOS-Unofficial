//
//  FleetVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

class MovementVC: UIViewController {
    
    let resourcesTopBarView = ResourcesBarView()
    let genericTableView = GenericTableView()
    
    var player: PlayerData
    var fleets: [Fleets]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movement"
        view.backgroundColor = .systemBackground
        
        configureResourcesTopBarView()
        configureGenericTableView()
        refresh()
    }
    
    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    func configureResourcesTopBarView() {
        resourcesTopBarView.pinToTopEdges(inView: view, aspectRatio: 0.2, topIsSafeArea: true)
        resourcesTopBarView.configureWith(resources: nil, player: player)
    }
    
    func configureGenericTableView() {
        genericTableView.pinToTopView(inView: view, toTopView: resourcesTopBarView)
        genericTableView.configureView(cellIdentifier: "FleetCell")
        genericTableView.tableView.delegate = self
        genericTableView.tableView.dataSource = self
        genericTableView.refreshCompletion = { [weak self] in
            self?.resourcesTopBarView.refresh(self?.player)
            self?.refresh()
        }
    }
    
    // MARK: - Refresh UI
    @objc func refresh() {
        Task {
            do {
                genericTableView.startUpdatingUI()
                fleets = try await OGCheckFleet.getFleetWith(playerData: player)
                genericTableView.stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
}

// MARK: - Delegates & DataSource
extension MovementVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fleets = fleets else { return 0 }
        return fleets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fleets = fleets else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FleetCell", for: indexPath) as! FleetCell
        cell.set(with: fleets[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
