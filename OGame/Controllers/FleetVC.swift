//
//  FleetVCViewController.swift
//  OGame
//
//  Created by Subvert on 13.01.2022.
//

import UIKit

class FleetVC: UIViewController {
    
    let tableView = UITableView()
    let nextButton = UIButton()
    let separator = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    var player: PlayerData?
    var buildingsDataModel: [BuildingWithAmount]?
    var textFieldValues = Array(repeating: 0, count: 15)
    var targetData: CheckTarget?
    var briefingData: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fleet"
        
        configureNextButton()
        configureSeparator()
        configureTableView()
        configureActivityIndicator()
        
        Task {
            do {
                let coordinates = player!.celestials[player!.currentPlanetIndex].coordinates
                let targetCoordinates = Coordinates(galaxy: coordinates[0],
                                                    system: coordinates[1],
                                                    position: coordinates[2])
                self.targetData = try await OGSendFleet.checkTarget(player: player!, whereTo: targetCoordinates)
                
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
        
        refresh()
    }
    
    // MARK: - Configure UI
    func configureNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.setTitleColor(.systemGray, for: .disabled)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        nextButton.isEnabled = false
    }
    
    func configureSeparator() {
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.topAnchor.constraint(equalTo: nextButton.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        separator.backgroundColor = .opaqueSeparator
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SendFleetCell", bundle: nil), forCellReuseIdentifier: "SendFleetCell")
        tableView.removeExtraCellLines()
        tableView.alpha = 0.5
        tableView.rowHeight = 88
        tableView.keyboardDismissMode = .onDrag
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Button Pressed
    @objc func nextButtonPressed() {
        for (index, _) in buildingsDataModel!.enumerated() {
            buildingsDataModel![index].amount = textFieldValues[index]
        }
        
        for item in textFieldValues where item != 0 {
            if let parent = self.parent as? GenericVC {
                parent.removeChildVC()
                let sendFleetVC = SendFleetVC()
                sendFleetVC.player = player
                sendFleetVC.ships = buildingsDataModel
                sendFleetVC.targetData = targetData
                parent.childVC = sendFleetVC
                parent.configureChildVC()
                break
            }
        }
    }
    
    // MARK: - Refresh UI
    @objc func refresh() {
        Task {
            do {
                guard let player = player else { return }
                startUpdatingUI()
                buildingsDataModel = try await OGShipyard.getShipsWith(playerData: player)
                buildingsDataModel?.removeLast(2)
                stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    func startUpdatingUI() {
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name("Build"), object: nil)
    }
    
    func stopUpdatingUI() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        tableView.isUserInteractionEnabled = true
        tableView.alpha = 1
        activityIndicator.stopAnimating()
    }
}

// MARK: - Delegate & DataSource
extension FleetVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildingsDataModel = self.buildingsDataModel else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendFleetCell", for: indexPath) as! SendFleetCell
        cell.shipSelectedTextField.tag = indexPath.row
        cell.shipSelectedTextField.delegate = self
        cell.shipSelectedTextField.text = String(textFieldValues[indexPath.row])
        cell.setShip(with: buildingsDataModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        textFieldValues.remove(at: textField.tag)
        textFieldValues.insert(Int(textField.text!)!, at: textField.tag)
        for item in textFieldValues {
            if item != 0 {
                nextButton.isEnabled = true
                break
            } else {
                nextButton.isEnabled = false
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let startPosition = textField.beginningOfDocument
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: startPosition, to: endPosition)
    }
}
