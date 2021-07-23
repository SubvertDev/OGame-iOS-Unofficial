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
    @IBOutlet weak var serverNameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goToSegue), name: Notification.Name("didInit"), object: nil)
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
        // TODO: Add check for empty fields
        // TODO: Make a falling list of servers
        loginButton.isEnabled = false
        OGame.shared.loginIntoAccount(username: emailTextField.text!,
                                      password: passwordTextField.text!) { errorMessage in
            if let message = errorMessage {
                self.loginButton.isEnabled = true
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }

    }
    
    @objc func goToSegue() {
        loginButton.isEnabled = true
        performSegue(withIdentifier: "ShowServerListVC", sender: self)
    }
}

