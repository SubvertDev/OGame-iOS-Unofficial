//
//  TableViewWithRefresh.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

class MenuTableView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        guard let view = self.loadViewFrobNib(nibName: "MenuTableView") else { return }
        addSubview(view)
        view.frame = self.bounds
        
        configureTableView()
        configureRefreshControl()
    }
    
    func configureTableView() {
        tableView.removeExtraCellLines()
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
    }
    
    func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(nil, action: #selector(MenuVC.tableViewRefreshCalled), for: .valueChanged)
    }
}
