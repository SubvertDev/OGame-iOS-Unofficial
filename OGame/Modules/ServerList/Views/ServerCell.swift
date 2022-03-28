//
//  ServerCell.swift
//  OGame
//
//  Created by Subvert on 26.07.2021.
//

import UIKit

final class ServerCell: UITableViewCell {

    @IBOutlet weak var serverName: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var language: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Public
    func set(with server: MyServer) {
        serverName.text = server.serverName
        playerName.text = server.accountName
        language.text = server.language.uppercased()
    }
}
