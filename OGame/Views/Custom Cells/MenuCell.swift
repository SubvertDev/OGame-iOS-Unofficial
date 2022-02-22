//
//  MenuCell.swift
//  OGame
//
//  Created by Subvert on 30.01.2022.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let label = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = .disclosureIndicator
        configureLabel()
    }
    
    func configureLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 44)
        ])
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
}
