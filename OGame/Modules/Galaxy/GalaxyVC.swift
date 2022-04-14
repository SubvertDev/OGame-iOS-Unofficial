//
//  GalaxyVC.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import UIKit

protocol IGalaxyView: AnyObject {
    func showLoading(_ state: Bool)
    func reloadTable(with: [Position?])
    func updateTextFields(with: [Int], type: TextFieldType)
    func showAlert(error: Error)
}

enum TextFieldType {
    case galaxy, system
}

final class GalaxyVC: BaseViewController {
    
    // MARK: Properties
    var player: PlayerData
    var systemInfo: [Position?]?
    var currentCoordinates = [1, 1]
    var presenter: GalaxyPresenterDelegate!
    
    var myView: GalaxyView { return view as! GalaxyView }
        
    // MARK: View Lifecycle
    override func loadView() {
        view = GalaxyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.galaxy
        configureView()
        presenter = GalaxyPresenter(view: self)
        presenter.viewDidLoad(coords: currentCoordinates, player: player)
    }

    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func configureView() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        currentCoordinates = player.celestials[player.currentPlanetIndex].coordinates
        myView.galaxyTextField.text = "\(currentCoordinates[0])"
        myView.systemTextField.text = "\(currentCoordinates[1])"

        myView.setDelegates(self)
    }
}

// MARK: - GalaxyView Control Delegate
extension GalaxyVC: IGalaxyViewControl {
    func galaxyLeftButtonTapped() {
        presenter.galaxyChanged(coords: currentCoordinates, direction: .left, player: player)
    }
    
    func galaxyRightButtonTapped() {
        presenter.galaxyChanged(coords: currentCoordinates, direction: .right, player: player)
    }
    
    func galaxyTextFieldChanged(_ sender: UITextField) {
        presenter.galaxyTextFieldChanged(coords: currentCoordinates, player: player, sender: sender)
    }
    
    func systemLeftButtonTapped() {
        presenter.systemChanged(coords: currentCoordinates, direction: .left, player: player)
    }
    
    func systemRightButtonTapped() {
        presenter.systemChanged(coords: currentCoordinates, direction: .right, player: player)
    }
    
    func systemTextFieldChanged(_ sender: UITextField) {
        presenter.systemTextFieldChanged(coords: currentCoordinates, player: player, sender: sender)
    }
}

// MARK: - GalaxyView Delegate
extension GalaxyVC: IGalaxyView {
    func showLoading(_ state: Bool) {
        myView.showLoading(state)
    }
    
    func reloadTable(with positions: [Position?]) {
        systemInfo = positions
        myView.updateTableView()
    }
    
    func updateTextFields(with coords: [Int], type: TextFieldType) {
        currentCoordinates = coords
        switch type {
        case .galaxy:
            myView.galaxyTextField.text = "\(coords[0])"
        case .system:
            myView.systemTextField.text = "\(coords[1])"
        }
    }
    
    func showAlert(error: Error) {
        logoutAndShowError(error as! OGError)
    }
}

// MARK: - TableView Delegate & DataSource
extension GalaxyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return systemInfo?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let systemInfo = systemInfo else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.galaxyCell, for: indexPath) as! GalaxyCell
        cell.set(with: systemInfo, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
