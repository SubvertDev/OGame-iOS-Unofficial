//
//  OverviewTotalView.swift
//  OGame
//
//  Created by Subvert on 01.02.2022.
//

import UIKit

class OverviewTotalView: UIView {

    let resourcesTopBarView = ResourcesTopBarView()
    let overviewInfoView = OverviewInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func configureViews() {
        backgroundColor = .systemBackground
        configureTopView()
        configureBottomView()
    }

    func configureTopView() {
        addSubview(resourcesTopBarView)
        resourcesTopBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resourcesTopBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resourcesTopBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resourcesTopBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resourcesTopBarView.heightAnchor.constraint(equalTo: resourcesTopBarView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    func configureBottomView() {
        addSubview(overviewInfoView)
        overviewInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewInfoView.topAnchor.constraint(equalTo: resourcesTopBarView.bottomAnchor),
            overviewInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overviewInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
