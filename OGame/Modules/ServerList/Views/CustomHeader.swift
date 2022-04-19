//
//  CustomHeader.swift
//  OGame
//
//  Created by Subvert on 4/18/22.
//

import UIKit

final class CustomHeader: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let universeLabel: UILabel = {
        let label = UILabel()
        label.text = "Universe/Name"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let onlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Online"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Rank"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(universeLabel)
        stackView.addArrangedSubview(onlineLabel)
        stackView.addArrangedSubview(rankLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            onlineLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2),
            rankLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.15)
        ])
    }
}
