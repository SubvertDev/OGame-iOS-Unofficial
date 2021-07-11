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
    
    var object: OGame?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goToSegue), name: Notification.Name("didFullInit"), object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        object = OGame(universe: serverNameTextField.text!, username: emailTextField.text!, password: passwordTextField.text!)
        
    }
    
    @objc func goToSegue() {
        performSegue(withIdentifier: "ShowMenuVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuVC = segue.destination as? MenuVC {
            menuVC.object = object
        }
    }
}

