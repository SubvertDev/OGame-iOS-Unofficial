//
//  LoginViewDelegate.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import UIKit
import Alamofire

protocol ILoginView: AnyObject {
    func showLoading(_ state: Bool)
    func performLogin(servers: [MyServer])
    func showAlert(error: OGError)
}

final class LoginVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var formView: UIView!
    
    private var presenter: LoginPresenter!
    private let defaults = UserDefaults.standard
    private var servers: [MyServer]?
    private var username = ""
    private var password = ""
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFormView()
        configureGestureRecognizer()
        configureInputViews()
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
        formView.layer.borderColor = UIColor.label.cgColor
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTouchDown(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        username = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordTextField.text!
        
        presenter.login(username: username, password: password)
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.showServerListVC {
            let serverListVC = segue.destination as! ServerListVC
            serverListVC.servers = servers
        }
    }
    
    // MARK: - Private
    private func configureFormView() {
        formView.layer.borderWidth = 2
        formView.layer.borderColor = UIColor.label.cgColor
        formView.layer.cornerRadius = 10
        formView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.65)
    }
    
    private func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureInputViews() {
        if defaults.object(forKey: K.Defaults.username) != nil {
            emailTextField.text = defaults.string(forKey: K.Defaults.username)
            passwordTextField.text = defaults.string(forKey: K.Defaults.password)
            saveSwitch.setOn(true, animated: false)
        }
    }
}

// MARK: - LoginViewDelegate
extension LoginVC: ILoginView {
    func showLoading(_ state: Bool) {
        if state {
            loginButton.isHidden = true
            activityIndicator.startAnimating()
        } else {
            loginButton.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    func performLogin(servers: [MyServer]) {
        self.servers = servers
        if saveSwitch.isOn {
            defaults.set(username, forKey: K.Defaults.username)
            defaults.set(password, forKey: K.Defaults.password)
        }
        performSegue(withIdentifier: K.Segue.showServerListVC, sender: self)
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}
