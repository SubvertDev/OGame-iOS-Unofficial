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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        OGame.shared.loginIntoAccount(username: username,
                                      password: password) { result in
            switch result {
            case .success(_):
                print("success")
                self.loginButton.isHidden = false
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "ShowServerListVC", sender: self)
                
            case .failure(let error):
                print("error")
                self.loginButton.isEnabled = true
                let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
            
            self.loginButton.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
}

