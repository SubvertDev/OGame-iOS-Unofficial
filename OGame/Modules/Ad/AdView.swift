//
//  AdView.swift
//  OGame
//
//  Created by Subvert on 4/15/22.
//

import UIKit

protocol AdViewDelegate {
    func adButtonPressed(ad: Ad)
}

final class AdView: UIView {
    
    private let adButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.addTarget(self, action: #selector(adButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var ad: Ad?
    var delegate: AdViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard !K.debugMode else { return }
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func setAds(_ ads: [Ad]) {
        let ad = ads[Int.random(in: 0..<ads.count)]
        self.ad = ad
        adButton.setTitle(ad.title, for: .normal)
    }
    
    // MARK: Private
    @objc private func adButtonPressed() {
        guard let ad = ad else { return }
        delegate?.adButtonPressed(ad: ad)
    }
    
    private func addSubviews() {
        addSubview(adButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            adButton.topAnchor.constraint(equalTo: topAnchor),
            adButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            adButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            adButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
