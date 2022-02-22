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

    func pinToEdges(constant: CGFloat = 0, inView superview: UIView) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant).isActive = true
    }
    
    func pinToTopEdges(constant: CGFloat = 0, inView superview: UIView, aspectRatio: CGFloat = 1, topIsSafeArea: Bool = false) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        if topIsSafeArea {
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        }
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant).isActive = true
        if aspectRatio != 1 {
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspectRatio).isActive = true
        }
    }
    
    func pinToTopView(constant: CGFloat = 0, inView superview: UIView, toTopView topView: UIView, isBottomAnchor: Bool = true) {
        superview.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: constant).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant).isActive = true
        if isBottomAnchor {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant).isActive = true
        }
    }
}
