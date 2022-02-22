//
//  MenuView.swift
//  OGame
//
//  Created by Subvert on 29.01.2022.
//

import UIKit

class MenuView: UIView {
    
    let planetInfoView = PlanetControlView()
    let resourcesTopBarView = ResourcesTopBarView()
    let tableView = UITableView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func configureViews() {
        configurePlanetInfoView()
        //configureResourcesTopBarView()
        configureTableView()
    }
    
    func configurePlanetInfoView() {
        addSubview(planetInfoView)
        planetInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            planetInfoView.topAnchor.constraint(equalTo: topAnchor),
            planetInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            planetInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            planetInfoView.heightAnchor.constraint(equalTo: planetInfoView.widthAnchor, multiplier: 2.5)
        ])
    }
    
//    func configureResourcesTopBarView() {
//
//    }
    
    func configureTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: planetInfoView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.removeExtraCellLines()
        //tableView.alpha = 0.5
        tableView.rowHeight = 88
    }
}
