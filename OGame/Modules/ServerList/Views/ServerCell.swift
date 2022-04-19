//
//  ServerCell.swift
//  OGame
//
//  Created by Subvert on 26.07.2021.
//

import UIKit

final class ServerCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.098, green: 0.137, blue: 0.188, alpha: 1).cgColor
        view.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let universeNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let serverNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Server name"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Player name"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let onlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Online"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Rank"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .clear
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 0.145, green: 0.207, blue: 0.254, alpha: 1)
        selectedBackgroundView = bgView
        addSubviews()
        makeConstraints()
    }
    
    // MARK: Public
    func set(with server: MyServer) {
        serverNameLabel.text = "\(server.serverName) [\(server.language.uppercased())]"
        playerNameLabel.text = server.accountName
        onlineLabel.text = String(server.online)
        rankLabel.text = server.rank
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(containerView)
        addSubview(stackView)
        stackView.addArrangedSubview(universeNameStackView)
                
        universeNameStackView.addArrangedSubview(serverNameLabel)
        universeNameStackView.addArrangedSubview(playerNameLabel)
        
        stackView.addArrangedSubview(onlineLabel)
        stackView.addArrangedSubview(rankLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            onlineLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2),
            rankLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.15)
        ])
    }
}
