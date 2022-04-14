//
//  LoginVC.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import UIKit

protocol ILoginView: AnyObject {
    func showLoading(_ state: Bool)
    func performLogin(servers: [MyServer])
    func showAlert(error: OGError)
}

final class LoginVC: UIViewController {
    
    private var presenter: LoginPresenter!
    private let defaults = UserDefaults.standard
    private var servers: [MyServer]?
    private var username = ""
    private var password = ""
    
    private var myView: LoginView { return view as! LoginView}
    
    // MARK: - View Lifecycle
    override func loadView() {
        let loginView = LoginView()
        loginView.delegate = self
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        if defaults.object(forKey: K.Defaults.username) != nil {
            myView.loginTextField.text = defaults.string(forKey: K.Defaults.username)
            myView.passwordTextField.text = defaults.string(forKey: K.Defaults.password)
            myView.saveSwitch.setOn(true, animated: false)
        }
        
        presenter = LoginPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        myView.embedView.layer.borderColor = UIColor.label.cgColor
    }
}

// MARK: - LoginButton Protocol
extension LoginVC: ILoginButton {
    func loginButtonPressed() {
        myView.loginTextField.resignFirstResponder()
        myView.passwordTextField.resignFirstResponder()
        
        username = myView.loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = myView.passwordTextField.text!
        
        presenter.login(username: username, password: password)
    }
    
    func loginButtonTouchDown() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// MARK: - LoginView Delegate
extension LoginVC: ILoginView {
    func showLoading(_ state: Bool) {
        myView.showLoading(state)
    }
    
    func performLogin(servers: [MyServer]) {
        self.servers = servers
        if myView.saveSwitch.isOn {
            defaults.set(username, forKey: K.Defaults.username)
            defaults.set(password, forKey: K.Defaults.password)
        }
        let serverListVC = ServerListVC(servers: servers)
        navigationController?.pushViewController(serverListVC, animated: true)
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}
