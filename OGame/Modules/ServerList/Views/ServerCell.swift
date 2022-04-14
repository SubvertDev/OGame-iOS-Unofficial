//
//  ServerCell.swift
//  OGame
//
//  Created by Subvert on 26.07.2021.
//

import UIKit

final class ServerCell: UITableViewCell {

//    @IBOutlet weak var serverName: UILabel!
//    @IBOutlet weak var playerName: UILabel!
//    @IBOutlet weak var language: UILabel!
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "XX"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let serverNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Server name"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Player name"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = .disclosureIndicator
        addSubviews()
        makeConstraints()
    }
    
    // MARK: Public
    func set(with server: MyServer) {
        serverNameLabel.text = server.serverName
        playerNameLabel.text = server.accountName
        languageLabel.text = server.language.uppercased()
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(languageLabel)
        addSubview(serverNameLabel)
        addSubview(playerNameLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: topAnchor),
            languageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            languageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            languageLabel.widthAnchor.constraint(equalTo: heightAnchor),
            
            serverNameLabel.leadingAnchor.constraint(equalTo: languageLabel.trailingAnchor),
            serverNameLabel.topAnchor.constraint(equalTo: languageLabel.topAnchor, constant: 13),
            
            playerNameLabel.leadingAnchor.constraint(equalTo: serverNameLabel.leadingAnchor),
            playerNameLabel.topAnchor.constraint(equalTo: serverNameLabel.bottomAnchor, constant: 8)
        ])
    }
}
