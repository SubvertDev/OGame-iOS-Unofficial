//
//  UIView+Ext.swift
//  OGame
//
//  Created by Subvert on 22.05.2021.
//

import UIKit

extension UIView {
    func loadViewFrobNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
