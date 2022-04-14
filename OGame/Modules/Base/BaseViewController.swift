//
//  BaseViewController.swift
//  OGame
//
//  Created by Subvert on 4/10/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonPressed))
    }
    
    // MARK: Private
    @objc private func logoutButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
