//
//  GalaxyVC.swift
//  OGame
//
//  Created by Subvert on 3/16/22.
//

import UIKit

protocol GalaxyViewDelegate: AnyObject {
    func showLoading(_ state: Bool)
    func reloadTable(with: [Position?])
    func updateTextFields(with: [Int], type: TextFieldType)
    func showAlert(error: Error)
}

enum TextFieldType {
    case galaxy, system
}

final class GalaxyVC: UIViewController {
    
    // MARK: - Properties
    var galaxyPresenter: GalaxyPresenterDelegate!
    var player: PlayerData
    var systemInfo: [Position?]?
    var currentCoordinates = [1, 1]
    
    var myView: GalaxyView { return view as! GalaxyView }
        
    override func loadView() {
        view = GalaxyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Galaxy"
        configureView()
        
        galaxyPresenter = GalaxyPresenter(view: self)
        galaxyPresenter.viewDidLoad(coords: currentCoordinates, player: player)
    }

    init(player: PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure View
    func configureView() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        currentCoordinates = player.celestials[player.currentPlanetIndex].coordinates
        myView.galaxyTextField.text = "\(currentCoordinates[0])"
        myView.systemTextField.text = "\(currentCoordinates[1])"
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
    }
    
    // MARK: - Actions
    @objc func galaxyLeftButtonPressed() {
        galaxyPresenter.galaxyChanged(coords: currentCoordinates, direction: .left, player: player)
    }
    
    @objc func galaxyRightButtonPressed() {
        galaxyPresenter.galaxyChanged(coords: currentCoordinates, direction: .right, player: player)
    }
    
    @objc func systemLeftButtonPressed() {
        galaxyPresenter.systemChanged(coords: currentCoordinates, direction: .left, player: player)
    }
    
    @objc func systemRightButtonPressed() {
        galaxyPresenter.systemChanged(coords: currentCoordinates, direction: .right, player: player)
    }
    
    @objc func galaxyTextFieldChanged() {
        galaxyPresenter.galaxyTextFieldChanged(coords: currentCoordinates, player: player, sender: myView.galaxyTextField)
    }
    
    @objc func systemTextFieldChanged() {
        galaxyPresenter.systemTextFieldChanged(coords: currentCoordinates, player: player, sender: myView.systemTextField)
    }
}

// MARK: - GalaxyViewDelegate
extension GalaxyVC: GalaxyViewDelegate {
    func showLoading(_ state: Bool) {
        if state {
            myView.activityIndicator.startAnimating()
            myView.tableView.alpha = 0.5
            myView.tableView.isUserInteractionEnabled = false
        } else {
            myView.activityIndicator.stopAnimating()
            myView.tableView.alpha = 1
            myView.tableView.isUserInteractionEnabled = true
        }
    }
    
    func reloadTable(with positions: [Position?]) {
        systemInfo = positions
        myView.tableView.reloadData()
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
        let alert = UIAlertController(title: (error as! OGError).message, message: (error as! OGError).detailed, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Delegate & DataSource
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
