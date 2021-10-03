//
//  UITableView+Ext.swift
//  OGame
//
//  Created by Subvert on 26.07.2021.
//

import UIKit

extension UITableView {
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
}
