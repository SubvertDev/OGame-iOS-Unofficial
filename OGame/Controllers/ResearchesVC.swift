//
//  ResearchVC.swift
//  OGame
//
//  Created by Subvert on 26.05.2021.
//

import UIKit

class ResearchVC: UIViewController {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()

    var researchCell: ResearchCell?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Research"

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
        tableView.alpha = 0.5
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

    // MARK: - REFRESH DATA ON RESEARCHES VC
    func refresh() {
        OGame.shared.research() { result in
            switch result {
            case .success(let researches):
                self.researchCell = ResearchCell(with: researches)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.tableView.isUserInteractionEnabled = true
                    self.tableView.alpha = 1
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                self.logoutAndShowError(error)
            }
        }
    }

    @objc func refreshTableView() {
        refresh()
    }
}

extension ResearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let researchCell = self.researchCell else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.setResearch(id: indexPath.row, researchTechnologies: researchCell.researchTechnologies)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResearchVC: BuildingCellDelegate {
    func didTapButton(_ cell: BuildingCell, _ type: (Int, Int, String)) {
        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        activityIndicator.startAnimating()
        
        OGame.shared.build(what: type, id: 0) { result in
            switch result {
            case .success(_):
                self.refresh()
                NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
                
            case .failure(let error):
                self.logoutAndShowError(error)
            }
        }
    }
}
