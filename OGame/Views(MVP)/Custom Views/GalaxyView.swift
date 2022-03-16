//
//  GalaxyView.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import UIKit

final class GalaxyView: UIView {
    
    let mainStackView = UIStackView()
    let controlStackView = UIStackView()
    
    // Refactor to custom view? vvv
    let galaxyStackView = UIStackView()
    let galaxyLeftButton = UIButton()
    let galaxyRightButton = UIButton()
    let galaxyTextField = UITextField()
    
    let systemStackView = UIStackView()
    let systemLeftButton = UIButton()
    let systemRightButton = UIButton()
    let systemTextField = UITextField()
    // Refactor to custom view? ^^^
    
    let separatorView = UIView()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        configureMainStackView()
        configureControlStackView()
        configureGalaxyStackView()
        configureSystemStackView()
        configureSeparatorView()
        configureTableView()
        configureActivityIndicator()
    }
    
    func configureMainStackView() {
        addSubview(mainStackView)
        mainStackView.pinToEdgesSafe(inView: self)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
    }
    
    func configureControlStackView() {
        mainStackView.addArrangedSubview(controlStackView)
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([controlStackView.heightAnchor.constraint(equalToConstant: 44)])
        controlStackView.axis = .horizontal
        controlStackView.spacing = 8
        controlStackView.alignment = .center
        controlStackView.distribution = .fillEqually
    }
    
    func configureGalaxyStackView() {
        controlStackView.addArrangedSubview(galaxyStackView)
        
        galaxyStackView.axis = .horizontal
        galaxyStackView.spacing = 0
        galaxyStackView.alignment = .fill
        galaxyStackView.distribution = .fillProportionally
        
        galaxyStackView.addArrangedSubview(galaxyLeftButton)
        galaxyLeftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        galaxyLeftButton.addTarget(nil, action: #selector(GalaxyVC.galaxyLeftButtonPressed), for: .touchUpInside)

        galaxyStackView.addArrangedSubview(galaxyTextField)
        galaxyTextField.placeholder = "Galaxy"
        galaxyTextField.textAlignment = .center
        galaxyTextField.keyboardType = .numberPad
        galaxyTextField.borderStyle = .roundedRect
        galaxyTextField.addTarget(nil, action: #selector(GalaxyVC.galaxyTextFieldChanged), for: .editingDidEnd)
        
        galaxyStackView.addArrangedSubview(galaxyRightButton)
        galaxyRightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        galaxyRightButton.addTarget(nil, action: #selector(GalaxyVC.galaxyRightButtonPressed), for: .touchUpInside)
    }
    
    func configureSystemStackView() {
        controlStackView.addArrangedSubview(systemStackView)
        
        systemStackView.axis = .horizontal
        systemStackView.spacing = 0
        systemStackView.alignment = .fill
        systemStackView.distribution = .fillProportionally
        
        systemStackView.addArrangedSubview(systemLeftButton)
        systemLeftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        systemLeftButton.addTarget(nil, action: #selector(GalaxyVC.systemLeftButtonPressed), for: .touchUpInside)

        systemStackView.addArrangedSubview(systemTextField)
        systemTextField.placeholder = "System"
        systemTextField.textAlignment = .center
        systemTextField.keyboardType = .numberPad
        systemTextField.borderStyle = .roundedRect
        systemTextField.addTarget(nil, action: #selector(GalaxyVC.systemTextFieldChanged), for: .editingDidEnd)
        
        systemStackView.addArrangedSubview(systemRightButton)
        systemRightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        systemRightButton.addTarget(nil, action: #selector(GalaxyVC.systemRightButtonPressed), for: .touchUpInside)
    }
    
    func configureSeparatorView() {
        mainStackView.addArrangedSubview(separatorView)
        separatorView.backgroundColor = .opaqueSeparator

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureTableView() {
        mainStackView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 66
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: "GalaxyCell", bundle: nil), forCellReuseIdentifier: "GalaxyCell")
    }
    
    func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}
