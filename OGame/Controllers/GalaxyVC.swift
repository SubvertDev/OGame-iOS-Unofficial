//
//  GalaxyVC.swift
//  OGame
//
//  Created by Subvert on 29.07.2021.
//

import UIKit

class GalaxyVC: UIViewController {

    @IBOutlet weak var galaxyTextField: UITextField!
    @IBOutlet weak var systemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    var systemInfo: [Position?]?
    var currentCoordinates = [1, 1]

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        currentCoordinates = OGame.shared.celestial!.coordinates

        galaxyTextField.text = "\(currentCoordinates[0])"
        systemTextField.text = "\(currentCoordinates[1])"

//        galaxyTextField.delegate = self
//        systemTextField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 88
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: "GalaxyCell", bundle: nil), forCellReuseIdentifier: "GalaxyCell")

        startedUpdating()

        OGame.shared.getGalaxy(coordinates: currentCoordinates) { result in
            switch result {
            case .success(let planets):
                self.systemInfo = planets
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stoppedUpdating()
                }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    func startedUpdating() {
        activityIndicator.startAnimating()
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
    }

    func stoppedUpdating() {
        activityIndicator.stopAnimating()
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = true
    }

    @IBAction func galaxyTextFieldChanged(_ sender: UITextField) {
        if sender.text != "" {
            if Int(sender.text!)! > 4 {
                sender.text = "4"
            } else if Int(sender.text!)! < 1 {
                sender.text = "1"
            }

            currentCoordinates = [Int(sender.text!)!, currentCoordinates[1]]

            startedUpdating()

            OGame.shared.getGalaxy(coordinates: currentCoordinates) { result in
                switch result {
                case .success(let planets):
                    self.systemInfo = planets
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stoppedUpdating()
                    }
                case .failure(_):
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            sender.text = "\(currentCoordinates[0])"
        }
    }

    @IBAction func systemTextFieldChanged(_ sender: UITextField) {
        if sender.text != "" {
            if Int(sender.text!)! > 499 {
                sender.text = "499"
            } else if Int(sender.text!)! < 1 {
                sender.text = "1"
            }

            currentCoordinates = [currentCoordinates[0], Int(sender.text!)!]

            startedUpdating()

            OGame.shared.getGalaxy(coordinates: currentCoordinates) { result in
                switch result {
                case .success(let planets):
                    self.systemInfo = planets
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stoppedUpdating()
                    }
                case .failure(_):
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            sender.text = "\(currentCoordinates[1])"
        }
    }

    @IBAction func galaxyLeftPressed(_ sender: UIButton) {
        if currentCoordinates[0] - 1 == 0 {
            currentCoordinates = [4, currentCoordinates[1]]
        } else {
            currentCoordinates = [currentCoordinates[0] - 1, currentCoordinates[1]]
        }

        galaxyTextField.text = "\(currentCoordinates[0])"
        galaxyTextFieldChanged(galaxyTextField)
    }

    @IBAction func galaxyRightPressed(_ sender: UIButton) {
        if currentCoordinates[0] + 1 == 5 {
            currentCoordinates = [1, currentCoordinates[1]]
        } else {
            currentCoordinates = [currentCoordinates[0] + 1, currentCoordinates[1]]
        }

        galaxyTextField.text = "\(currentCoordinates[0])"
        galaxyTextFieldChanged(galaxyTextField)
    }

    @IBAction func systemLeftPressed(_ sender: UIButton) {
        if currentCoordinates[1] - 1 == 0 {
            currentCoordinates = [currentCoordinates[0], 499]
        } else {
            currentCoordinates = [currentCoordinates[0], currentCoordinates[1] - 1]
        }

        systemTextField.text = "\(currentCoordinates[1])"
        systemTextFieldChanged(systemTextField)
    }

    @IBAction func systemRightPressed(_ sender: UIButton) {
        if currentCoordinates[1] + 1 == 500 {
            currentCoordinates = [currentCoordinates[0], 1]
        } else {
            currentCoordinates = [currentCoordinates[0], currentCoordinates[1] + 1]
        }

        systemTextField.text = "\(currentCoordinates[1])"
        systemTextFieldChanged(systemTextField)
    }
}

extension GalaxyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let systemInfo = systemInfo else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "GalaxyCell", for: indexPath) as! GalaxyCell
        cell.set(with: systemInfo, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
