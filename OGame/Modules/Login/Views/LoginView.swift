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
        imageView.image = Images.loginBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.black.cgColor
        let secondColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1).withAlphaComponent(0.8).cgColor
        gradient.colors = [firstColor, secondColor]
        return gradient
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = -8
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
        label.text = "Username:"
        label.textColor = .white
        label.font = UIFont(name: "Verdana Bold", size: 18)
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.textColor = .white
        label.font = UIFont(name: "Verdana Bold", size: 18)
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
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    private let saveLabel: UILabel = {
        let label = UILabel()
        label.text = "Save login and password:"
        label.textColor = .white
        label.font = UIFont(name: "Verdana Bold", size: 15)
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
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        button.setBackgroundImage(Images.loginButtonBg, for: .normal)
        button.titleLabel?.font = UIFont(name: "Play-Bold", size: 25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(red: 0.227, green: 0.549, blue: 0.156, alpha: 1).cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
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
        loginTextField.isUserInteractionEnabled = !state
        passwordTextField.isUserInteractionEnabled = !state
        saveSwitch.isUserInteractionEnabled = !state
        loginButton.isHidden = state
        
        if state {
            activityIndicator.startAnimating()
        } else {
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
        embedView.layer.addSublayer(gradient)
        
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
            
            loginTextField.widthAnchor.constraint(equalTo: embedView.widthAnchor, multiplier: 0.57),
            passwordTextField.widthAnchor.constraint(equalTo: embedView.widthAnchor, multiplier: 0.57),
            
            saveLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16),
            saveLabel.leadingAnchor.constraint(equalTo: embedView.leadingAnchor, constant: 16),
            saveLabel.widthAnchor.constraint(equalToConstant: 220),
            
            saveSwitch.leadingAnchor.constraint(equalTo: saveLabel.trailingAnchor, constant: 8),
            saveSwitch.centerYAnchor.constraint(equalTo: saveLabel.centerYAnchor),
            
            loginButton.topAnchor.constraint(equalTo: saveLabel.bottomAnchor, constant: 16),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            loginButton.widthAnchor.constraint(equalToConstant: 180),
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
