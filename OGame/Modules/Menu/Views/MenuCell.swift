//
//  MenuCell.swift
//  OGame
//
//  Created by Subvert on 30.01.2022.
//

import UIKit

final class MenuCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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
    func set(with title: String) {
        label.text = title
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(label)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
