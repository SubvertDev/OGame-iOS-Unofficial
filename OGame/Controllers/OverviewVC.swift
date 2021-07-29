//
//  OverviewVC.swift
//  OGame
//
//  Created by Subvert on 18.05.2021.
//

import UIKit

class OverviewVC: UIViewController {
    // TODO: Finish this VC
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var resourceCell: ResourceCell?
    var facilityCell: FacilityCell?
    var researchCell: ResearchCell?
    var shipsCell: ShipsCell?
    var defencesCell: DefenceCell?

    var resourcesActive = false
    var facilitiesActive = false
    var researchesActive = false
    var shipyardActive = false
    var defencesActive = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureActivityIndicator()

        refresh()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        tableView.removeExtraCellLines()
        //tableView.alpha = 0.5
        tableView.rowHeight = 88

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }

    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])

        activityIndicator.startAnimating()
    }

    func refresh() {
        getResources()
        getFacilities()
        getResearches()
        getShips()
        getDefences()
        refreshControl.endRefreshing()
        activityIndicator.stopAnimating()
    }

    @objc func refreshTableView() {
        refresh()
    }

    func getResources() {
        OGame.shared.supply(forID: 0) { result in
            switch result {
            case .success(let supplies):
                self.resourceCell = ResourceCell(with: supplies)
                for item in self.resourceCell!.resourceBuildings {
                    if item.condition == "active" {
                        self.resourcesActive = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        break
                    }
                }


            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func getFacilities() {
        OGame.shared.facilities(forID: 0) { result in
            switch result {
            case .success(let facilities):
                self.facilityCell = FacilityCell(with: facilities)
                for item in self.facilityCell!.facilityBuildings {
                    if item.condition == "active" {
                        self.facilitiesActive = true
                        self.activityIndicator.stopAnimating()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        break
                    }
                }

            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func getResearches() {
        OGame.shared.research(forID: 0) { result in
            switch result {
            case .success(let researches):
                self.researchCell = ResearchCell(with: researches)
                for item in self.researchCell!.researchTechnologies {
                    if item.condition == "active" {
                        self.researchesActive = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        break
                    }
                }

            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func getShips() {
        OGame.shared.ships(forID: 0) { result in
            switch result {
            case .success(let ships):
                self.shipsCell = ShipsCell(with: ships)
                for item in self.shipsCell!.shipsTechnologies {
                    if item.condition == "active" {
                        self.shipyardActive = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        break
                    }
                }

            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func getDefences() {
        OGame.shared.defences(forID: 0) { result in
            switch result {
            case .success(let defences):
                self.defencesCell = DefenceCell(with: defences)
                for item in self.defencesCell!.defenceTechnologies {
                    if item.condition == "active" {
                        self.defencesActive = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                        break
                    }
                }

            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell

        switch indexPath.section {
        case 0:
            if resourcesActive {
                for (index, item) in resourceCell!.resourceBuildings.enumerated() {
                    if item.condition == "active" {
                        cell.setSupply(id: index, resourceBuildings: resourceCell!.resourceBuildings)
                        cell.buildingImage.image = resourceCell!.resourceBuildings[index].image.available
                        cell.buildButton.isHidden = true
                        return cell
                    }
                }
            } else if facilitiesActive {
                for (index, item) in facilityCell!.facilityBuildings.enumerated() {
                    if item.condition == "active" {
                        cell.setFacility(id: index, facilityBuildings: facilityCell!.facilityBuildings)
                        cell.buildingImage.image = facilityCell!.facilityBuildings[index].image.available
                        cell.buildButton.isHidden = true
                        return cell
                    }
                }
            }
        case 1:
            if researchesActive {
                for (index, item) in researchCell!.researchTechnologies.enumerated() {
                    if item.condition == "active" {
                        cell.setResearch(id: index, researchTechnologies: researchCell!.researchTechnologies)
                        cell.buildingImage.image = researchCell!.researchTechnologies[index].image.available
                        cell.buildButton.isHidden = true
                        return cell
                    }
                }
            }
        case 2:
            if shipyardActive {
                for (index, item) in shipsCell!.shipsTechnologies.enumerated() {
                    if item.condition == "active" {
                        cell.setShip(id: index, shipsTechnologies: shipsCell!.shipsTechnologies)
                        cell.buildingImage.image = shipsCell!.shipsTechnologies[index].image.available
                        cell.buildButton.isHidden = true
                        cell.amountTextField.isHidden = true
                        return cell
                    }
                }
            } else if defencesActive {
                for (index, item) in defencesCell!.defenceTechnologies.enumerated() {
                    if item.condition == "active" {
                        cell.setDefence(id: index, defenceTechnologies: defencesCell!.defenceTechnologies)
                        cell.buildingImage.image = defencesCell!.defenceTechnologies[index].image.available
                        cell.buildButton.isHidden = true
                        cell.amountTextField.isHidden = true
                        return cell
                    }
                }
            }
        default:
            return UITableViewCell()
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OverviewVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
    }
}
