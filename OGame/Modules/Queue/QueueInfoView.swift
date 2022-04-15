//
//  QueueInfoView.swift
//  OGame
//
//  Created by Subvert on 4/10/22.
//

import UIKit

final class QueueInfoView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let queueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10 // fix not working
        return imageView
    }()
    
    private let levelOrAmountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func configureQueue(building: Building) {
        queueImageView.image = building.image.available
        levelOrAmountLabel.text = String(building.levelOrAmount)
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(queueImageView)
        stackView.addArrangedSubview(levelOrAmountLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            queueImageView.heightAnchor.constraint(equalToConstant: 30),
            queueImageView.widthAnchor.constraint(equalToConstant: 30),
            levelOrAmountLabel.heightAnchor.constraint(equalToConstant: 30),
            levelOrAmountLabel.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}
