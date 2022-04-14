//
//  LoginView.swift
//  OGame
//
//  Created by Subvert on 4/9/22.
//

import UIKit

protocol ILoginButton {
    func loginButtonPressed()
    func loginButtonTouchDown()
}

final class LoginView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let embedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.65)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .systemBackground
        textField.backgroundColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .systemBackground
        textField.backgroundColor = .label
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveLabel: UILabel = {
        let label = UILabel()
        label.text = "Save login and password"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveSwitch: UISwitch = {
        let saveSwitch = UISwitch()
        saveSwitch.isOn = false
        saveSwitch.translatesAutoresizingMaskIntoConstraints = false
        return saveSwitch
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ogame_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var delegate: ILoginButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func showLoading(_ state: Bool) {
        if state {
            loginButton.isHidden = true
            activityIndicator.startAnimating()
        } else {
            loginButton.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Private
    @objc private func loginButtonPressed() {
        delegate?.loginButtonPressed()
    }
    
    @objc private func loginButtonTouchDown() {
        delegate?.loginButtonTouchDown()
    }
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(embedView)
        
        addSubview(topStackView)
        topStackView.addArrangedSubview(labelsStackView)
        topStackView.addArrangedSubview(textFieldsStackView)
        
        labelsStackView.addArrangedSubview(loginLabel)
        labelsStackView.addArrangedSubview(passwordLabel)
        
        textFieldsStackView.addArrangedSubview(loginTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        addSubview(saveLabel)
        addSubview(saveSwitch)
        addSubview(loginButton)
        addSubview(activityIndicator)
        
        addSubview(logoImageView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            embedView.centerXAnchor.constraint(equalTo: centerXAnchor),
            embedView.centerYAnchor.constraint(equalTo: centerYAnchor),
            embedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            embedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            topStackView.topAnchor.constraint(equalTo: embedView.topAnchor, constant: 16),
            topStackView.leadingAnchor.constraint(equalTo: embedView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: embedView.trailingAnchor, constant: -16),
            
            saveSwitch.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16),
            saveSwitch.leadingAnchor.constraint(equalTo: embedView.leadingAnchor, constant: 16),
            
            saveLabel.leadingAnchor.constraint(equalTo: saveSwitch.trailingAnchor, constant: 12),
            saveLabel.centerYAnchor.constraint(equalTo: saveSwitch.centerYAnchor),
            
            loginButton.topAnchor.constraint(equalTo: saveSwitch.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: embedView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            logoImageView.heightAnchor.constraint(equalToConstant: 44),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 3)
        ])
    }
}
