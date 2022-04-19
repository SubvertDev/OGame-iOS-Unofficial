//
//  ServerListView.swift
//  OGame
//
//  Created by Subvert on 4/9/22.
//

import UIKit

final class ServerListView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.loginBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Choose your server:"
        label.textColor = .white
        label.font = UIFont(name: "Verdana Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let embedView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 0.098, green: 0.137, blue: 0.188, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        //tableView.alwaysBounceVertical = false
        tableView.rowHeight = 80
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ServerCell.self, forCellReuseIdentifier: K.CellReuseID.serverCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.black.cgColor
        let secondColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1).withAlphaComponent(0.8).cgColor
        gradient.colors = [firstColor, secondColor]
        return gradient
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        addSubview(backgroundImageView)
        addSubview(label)
        addSubview(embedView)
        embedView.layer.addSublayer(gradient)
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            embedView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            embedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            embedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            embedView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: embedView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: embedView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: embedView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: embedView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
