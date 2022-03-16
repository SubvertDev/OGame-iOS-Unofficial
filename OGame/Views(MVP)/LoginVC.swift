//
//  LoginViewDelegate.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import UIKit
import Alamofire

protocol LoginViewDelegate: AnyObject {
    func showLoading(_ state: Bool)
    func performLogin(servers: [MyServer])
    func showAlert(error: Error)
}

final class LoginVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var formView: UIView!
    
    private var loginPresenter: LoginPresenter!
    private let defaults = UserDefaults.standard
    private var servers: [MyServer]?
    private var username = ""
    private var password = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter = LoginPresenter(view: self)
        configureFormView()
        configureGestureRecognizer()
        configureInputViews()
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
    
    // MARK: - Configure UI
    func configureFormView() {
        formView.layer.borderWidth = 2
        formView.layer.borderColor = UIColor.label.cgColor
        formView.layer.cornerRadius = 10
        formView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.65)
    }
    
    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureInputViews() {
        if defaults.object(forKey: "username") != nil {
            emailTextField.text = defaults.string(forKey: "username")
            passwordTextField.text = defaults.string(forKey: "password")
            saveSwitch.setOn(true, animated: false)
        }
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTouchDown(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        username = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordTextField.text!
        
        loginPresenter.login(username: username, password: password)
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowServerListVC" {
            let serverListVC = segue.destination as! ServerListVC
            serverListVC.servers = servers
        }
    }
}

// MARK: - LoginViewDelegate
extension LoginVC: LoginViewDelegate {
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
            defaults.set(username, forKey: "username")
            defaults.set(password, forKey: "password")
        }
        performSegue(withIdentifier: "ShowServerListVC", sender: self)
    }
    
    func showAlert(error: Error) {
        let alert = UIAlertController(title: (error as! OGError).message, message: (error as! OGError).detailed, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
