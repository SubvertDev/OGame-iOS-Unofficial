//
//  ResourcesVC.swift
//  OGame
//
//  Created by Subvert on 19.05.2021.
//

import UIKit

class ResourcesVC: UIViewController {
    
    @IBOutlet weak var resourcesOverview: ResourcesOverview!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHider: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var prodPerSecond = [Double]()
    var resourceCell: ResourceCell?
    var timer: Timer?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)

        refresh()
    }

    // MARK: - REFRESH DATA ON RESOURCES VC
    func refresh() {
        OGame.shared.getResources(forID: 0) { result in
            switch result {
            case .success(let resources):
                self.resourcesOverview.set(metal: resources.metal,
                                           crystal: resources.crystal,
                                           deuterium: resources.deuterium,
                                           energy: resources.energy)

                for day in resources.dayProduction {
                    let dayDouble = Double(day)
                    self.prodPerSecond.append(dayDouble / 3600)
                }

                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.resourcesOverview.update(metal: self.prodPerSecond[0],
                                                  crystal: self.prodPerSecond[1],
                                                  deuterium: self.prodPerSecond[2],
                                                  storage: resources)
                })
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }

        OGame.shared.supply(forID: 0) { result in
            switch result {
            case .success(let supplies):
                self.resourceCell = ResourceCell(with: supplies)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.tableViewHider.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @objc func refreshTableView() {
        refresh()
    }
}

extension ResourcesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell

        guard let resourceCell = self.resourceCell else { return UITableViewCell() }

        cell.delegate = self
        cell.setSupply(id: indexPath.row, resourceBuildings: resourceCell.resourceBuildings)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResourcesVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        tableViewHider.isHidden = false
        activityIndicator.startAnimating()

        OGame.shared.build(what: type, id: 0) { result in
            switch result {
            case .success(_):
                self.refresh()
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
