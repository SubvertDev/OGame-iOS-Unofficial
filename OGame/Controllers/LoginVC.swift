//
//  ViewController.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var formView: UIView!

    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()

        formView.layer.borderWidth = 2
        formView.layer.borderColor = UIColor.label.cgColor
        formView.layer.cornerRadius = 10
        formView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.65)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        if defaults.object(forKey: "username") != nil {
            emailTextField.text = defaults.string(forKey: "username")
            passwordTextField.text = defaults.string(forKey: "password")
            saveSwitch.setOn(true, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func loginButtonTouchDown(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        let username = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let emailCheck = username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .range(of: emailPattern, options: .regularExpression)

        guard emailCheck != nil else { return }
        guard !password.isEmpty else { return }

        loginButton.isHidden = true
        activityIndicator.startAnimating()
        
        Task {
            do {
                try await OGame.shared.loginIntoAccount(username: username, password: password)
                
                loginButton.isHidden = false
                activityIndicator.stopAnimating()

                if saveSwitch.isOn {
                    defaults.set(username, forKey: "username")
                    defaults.set(password, forKey: "password")
                }

                performSegue(withIdentifier: "ShowServerListVC", sender: self)
                
            } catch {
                activityIndicator.stopAnimating()
                loginButton.isHidden = false
                
                let alert = UIAlertController(title: (error as! OGError).message, message: (error as! OGError).detailed, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        formView.layer.borderColor = UIColor.label.cgColor
    }
}
