//
//  UIViewController+Ext.swift
//  OGame
//
//  Created by Subvert on 02.10.2021.
//

import UIKit

extension UIViewController {

    func logoutAndShowError(_ error: OGError) {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let alertVC = UIAlertController(title: error.message, message: error.detailed, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertVC, animated: true)
            }
        }
    }
}
