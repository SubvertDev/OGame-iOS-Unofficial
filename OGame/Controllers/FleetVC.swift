//
//  FleetVCViewController.swift
//  OGame
//
//  Created by Subvert on 13.01.2022.
//

import UIKit

class FleetVC: UIViewController {
    
    let resourcesTopBarView = ResourcesTopBarView()
    let fleetPageButtonsView = FleetPageButtonsView()
    let genericTableView = GenericTableView()
    
    var player: PlayerData?
    var ships: [Building]?
    var textFieldValues = Array(repeating: 0, count: 15)
    var targetData: CheckTarget?
    var briefingData: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fleet"
        
        view.backgroundColor = .systemBackground
        
        configureResourcesTopBarView()
        configureButtonsView()
        configureGenericTableView()
        getTargetData()
        
        refresh()
    }
    
    // MARK: - Configure UI
    func configureResourcesTopBarView() {
        resourcesTopBarView.pinToTopEdges(inView: view, aspectRatio: 0.2, topIsSafeArea: true)
        resourcesTopBarView.configureWith(resources: nil, player: player)
    }
    
    func configureButtonsView() {
        fleetPageButtonsView.pinToTopView(inView: view, toTopView: resourcesTopBarView, isBottomAnchor: false)
        fleetPageButtonsView.nextButtonPressed = { [weak self] in
            self?.nextButtonPressed()
        }
        fleetPageButtonsView.resetButtonPressed = { [weak self] in
            self?.resetButtonPressed()
        }
    }
    
    func configureGenericTableView() {
        genericTableView.pinToTopView(inView: view, toTopView: fleetPageButtonsView)
        genericTableView.tableView.delegate = self
        genericTableView.tableView.dataSource = self
        genericTableView.configureView(cellIdentifier: "SendFleetCell")
        genericTableView.refreshCompletion = { [weak self] in
            self?.resourcesTopBarView.refresh(self?.player)
            self?.refresh()
        }
    }
    
    // MARK: - Buttons Actions
    func nextButtonPressed() {
        var shipsToSend = ships
        for (index, _) in ships!.enumerated() {
            shipsToSend![index].levelOrAmount = textFieldValues[index]
        }
        
        for item in textFieldValues where item != 0 {
            let vc = SendFleetVC()
            vc.player = player
            vc.ships = shipsToSend
            vc.targetData = targetData
            navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func resetButtonPressed() {
        fleetPageButtonsView.nextButton.isEnabled = false
        textFieldValues = Array(repeating: 0, count: 15)
        genericTableView.tableView.reloadData()
    }
    
    // MARK: - Refresh UI
    @objc func refresh() {
        Task {
            do {
                guard let player = player else { return }
                genericTableView.startUpdatingUI()
                ships = try await OGShipyard.getShipsWith(playerData: player)
                ships?.removeLast(2)
                genericTableView.stopUpdatingUI()
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    // MARK: - Get TargetData
    func getTargetData() {
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
    }
}

// MARK: - Delegate & DataSource
extension FleetVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ships = self.ships else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendFleetCell", for: indexPath) as! SendFleetCell
        cell.shipSelectedTextField.tag = indexPath.row
        cell.shipSelectedTextField.delegate = self
        cell.shipSelectedTextField.text = String(textFieldValues[indexPath.row])
        cell.setShip(with: ships[indexPath.row])
        
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
                fleetPageButtonsView.nextButton.isEnabled = true
                break
            } else {
                fleetPageButtonsView.nextButton.isEnabled = false
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let startPosition = textField.beginningOfDocument
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: startPosition, to: endPosition)
    }
}
