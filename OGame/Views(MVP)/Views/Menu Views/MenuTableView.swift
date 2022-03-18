//
//  TableViewWithRefresh.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

final class MenuTableView: UIView {
    
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
        
        tableView.removeExtraCellLines()
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(nil, action: #selector(MenuVC.tableViewRefreshCalled), for: .valueChanged)
    }
}
