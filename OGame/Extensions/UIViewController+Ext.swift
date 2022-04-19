//
//  UIViewController+Ext.swift
//  OGame
//
//  Created by Subvert on 02.10.2021.
//

import UIKit

extension UIViewController {
    
    func showAd(in vc: UIViewController, banner: Banner, callback: @escaping () -> ()) {
        let containerView = UIView()
        containerView.backgroundColor = .black.withAlphaComponent(0.75)
        containerView.frame = vc.view.frame
        
        let button = UIButton()
        button.setImage(banner.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = containerView.bounds
        button.addTarget(nil, action: #selector(ServerListVC.adButtonPressed(_:)), for: .touchUpInside)
        button.layer.name = banner.adLink
        containerView.addSubview(button)
        
        vc.view.addSubview(containerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            containerView.removeFromSuperview()
            callback()
        }
    }

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
