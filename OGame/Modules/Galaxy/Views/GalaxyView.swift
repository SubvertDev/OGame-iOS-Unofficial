//
//  GalaxyView.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import UIKit

protocol IGalaxyViewControl {
    func galaxyLeftButtonTapped()
    func galaxyRightButtonTapped()
    func galaxyTextFieldChanged(_ sender: UITextField)
    func systemLeftButtonTapped()
    func systemRightButtonTapped()
    func systemTextFieldChanged(_ sender: UITextField)
}

final class GalaxyView: UIView {
    
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        return mainStackView
    }()
    
    private let controlStackView: UIStackView = {
        let controlStackView = UIStackView()
        controlStackView.axis = .horizontal
        controlStackView.spacing = 8
        controlStackView.alignment = .center
        controlStackView.distribution = .fillEqually
        return controlStackView
    }()
    
    // Refactor to custom view? vvv
    private let galaxyStackView: UIStackView = {
        let galaxyStackView = UIStackView()
        galaxyStackView.axis = .horizontal
        galaxyStackView.spacing = 0
        galaxyStackView.alignment = .fill
        galaxyStackView.distribution = .fillProportionally
        return galaxyStackView
    }()
    
    private let galaxyLeftButton: UIButton = {
        let galaxyLeftButton = UIButton()
        galaxyLeftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        galaxyLeftButton.addTarget(self, action: #selector(galaxyLeftButtonTapped), for: .touchUpInside)
        return galaxyLeftButton
    }()
    
    private let galaxyRightButton: UIButton = {
        let galaxyRightButton = UIButton()
        galaxyRightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        galaxyRightButton.addTarget(self, action: #selector(galaxyRightButtonTapped), for: .touchUpInside)
        return galaxyRightButton
    }()
    
    let galaxyTextField: UITextField = {
        let galaxyTextField = UITextField()
        galaxyTextField.placeholder = K.Galaxy.Placeholder.galaxy
        galaxyTextField.textAlignment = .center
        galaxyTextField.keyboardType = .numberPad
        galaxyTextField.borderStyle = .roundedRect
        galaxyTextField.addTarget(self, action: #selector(galaxyTextFieldChanged), for: .editingDidEnd)
        return galaxyTextField
    }()
    
    private let systemStackView: UIStackView = {
        let systemStackView = UIStackView()
        systemStackView.axis = .horizontal
        systemStackView.spacing = 0
        systemStackView.alignment = .fill
        systemStackView.distribution = .fillProportionally
        return systemStackView
    }()
    
    private let systemLeftButton: UIButton = {
        let systemLeftButton = UIButton()
        systemLeftButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        systemLeftButton.addTarget(self, action: #selector(systemLeftButtonTapped), for: .touchUpInside)
        return systemLeftButton
    }()
    
    private let systemRightButton: UIButton = {
        let systemRightButton = UIButton()
        systemRightButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        systemRightButton.addTarget(self, action: #selector(systemRightButtonTapped), for: .touchUpInside)
        return systemRightButton
    }()
    
    let systemTextField: UITextField = {
        let systemTextField = UITextField()
        systemTextField.placeholder = K.Galaxy.Placeholder.system
        systemTextField.textAlignment = .center
        systemTextField.keyboardType = .numberPad
        systemTextField.borderStyle = .roundedRect
        systemTextField.addTarget(self, action: #selector(systemTextFieldChanged), for: .editingDidEnd)
        return systemTextField
    }()
    // Refactor to custom view? ^^^
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .opaqueSeparator
        return separatorView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 66
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: K.CellReuseID.galaxyCell, bundle: nil),
                           forCellReuseIdentifier: K.CellReuseID.galaxyCell)
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    var delegate: IGalaxyViewControl?
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func showLoading(_ state: Bool) {
        enableButtons(state)
        if state {
            activityIndicator.startAnimating()
            tableView.alpha = 0.5
            tableView.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            tableView.alpha = 1
            tableView.isUserInteractionEnabled = true
        }
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func setDelegates(_ delegate: UITableViewDelegate & UITableViewDataSource & IGalaxyViewControl) {
        self.delegate = delegate
        tableView.delegate = delegate
        tableView.dataSource = delegate
    }
    
    // MARK: Private
    private func enableButtons(_ state: Bool) {
        galaxyLeftButton.isEnabled = !state
        galaxyRightButton.isEnabled = !state
        systemLeftButton.isEnabled = !state
        systemRightButton.isEnabled = !state
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(controlStackView)
        controlStackView.addArrangedSubview(galaxyStackView)
        galaxyStackView.addArrangedSubview(galaxyLeftButton)
        galaxyStackView.addArrangedSubview(galaxyTextField)
        galaxyStackView.addArrangedSubview(galaxyRightButton)
        controlStackView.addArrangedSubview(systemStackView)
        systemStackView.addArrangedSubview(systemLeftButton)
        systemStackView.addArrangedSubview(systemTextField)
        systemStackView.addArrangedSubview(systemRightButton)
        mainStackView.addArrangedSubview(separatorView)
        mainStackView.addArrangedSubview(tableView)
        addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            controlStackView.heightAnchor.constraint(equalToConstant: 44),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    @objc private func galaxyLeftButtonTapped() {
        delegate?.galaxyLeftButtonTapped()
    }
    
    @objc private func galaxyRightButtonTapped() {
        delegate?.galaxyRightButtonTapped()
    }
    
    @objc private func galaxyTextFieldChanged(_ sender: UITextField) {
        delegate?.galaxyTextFieldChanged(sender)
    }
    
    @objc private func systemLeftButtonTapped() {
        delegate?.systemLeftButtonTapped()
    }
    
    @objc private func systemRightButtonTapped() {
        delegate?.systemRightButtonTapped()
    }
    
    @objc private func systemTextFieldChanged(_ sender: UITextField) {
        delegate?.systemTextFieldChanged(sender)
    }
}
