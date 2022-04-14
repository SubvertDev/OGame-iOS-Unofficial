//
//  FleetVC.swift
//  OGame
//
//  Created by Subvert on 13.01.2022.
//

import UIKit

protocol IFleetView: AnyObject {
    func showResourcesLoading(_ state: Bool)
    func updateResources(with: Resources)
    func showTableViewLoading(_ state: Bool)
    func updateTableView(with: [Building])
    func resetFleet()
    func setTarget(with: CheckTarget)
    func openSendFleetVC(with: [Building])
    func showAlert(error: OGError)
}

final class FleetVC: BaseViewController {
    
    // MARK: Properties
    private var player: PlayerData
    private var resources: Resources
    private var ships: [Building]?
    private var textFieldValues = Array(repeating: 0, count: 15)
    private var targetData: CheckTarget?
    private var briefingData: [String]?
    private var presenter: IFleetPresenter!
    
    private var myView: FleetView { return view as! FleetView }
    
    // MARK: View Lifecycle
    override func loadView() {
        view = FleetView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.fleet
        
        myView.setDelegates(self)
        myView.updateResources(with: resources)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        presenter = FleetPresenter(view: self)
        presenter.loadFleet(for: player)
        presenter.getTargetData(for: player)
    }
    
    init(player: PlayerData, resources: Resources) {
        self.player = player
        self.resources = resources
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - FleetView Delegate
extension FleetVC: IFleetView {
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResources(with resources: Resources) {
        myView.updateResources(with: resources)
    }
    
    func showTableViewLoading(_ state: Bool) {
        myView.showTableViewLoading(state)
    }
    
    func updateTableView(with ships: [Building]) {
        self.ships = ships
        myView.updateTableView()
    }
    
    func resetFleet() {
        myView.fleetPageButtonsView.nextButton.isEnabled = false
        textFieldValues = Array(repeating: 0, count: 15)
        myView.genericTableView.tableView.reloadData()
    }
    
    func setTarget(with target: CheckTarget) {
        targetData = target
    }
    
    func openSendFleetVC(with ships: [Building]) {
        let vc = SendFleetVC(player: player, ships: ships, target: targetData!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}

// MARK: - FleetPageButtons Delegate
extension FleetVC: IFleetPageButtonsView {
    func nextButtonTapped() {
        guard let ships = ships else { return }
        presenter.nextButtonTapped(with: ships, amount: textFieldValues)
    }
    
    func resetButtonTapped() {
        presenter.resetButtonTapped()
    }
}

// MARK: - GenericTableView Delegate
extension FleetVC: IGenericTableView {
    func refreshCalled() {
        presenter.loadResources(for: player)
        presenter.loadFleet(for: player)
    }
}

// MARK: - TableView Delegate & DataSource
extension FleetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ships?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ships = self.ships else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.sendFleetCell, for: indexPath) as! SendFleetCell
        cell.shipSelectedTextField.tag = indexPath.row
        cell.shipSelectedTextField.delegate = self
        cell.shipSelectedTextField.text = String(textFieldValues[indexPath.row])
        cell.setShip(with: ships[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TextField Delegate
extension FleetVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        textFieldValues.remove(at: textField.tag)
        textFieldValues.insert(Int(textField.text!)!, at: textField.tag)
        for item in textFieldValues {
            if item != 0 {
                myView.fleetPageButtonsView.nextButton.isEnabled = true
                break
            } else {
                myView.fleetPageButtonsView.nextButton.isEnabled = false
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let startPosition = textField.beginningOfDocument
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: startPosition, to: endPosition)
    }
}
