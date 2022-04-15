//
//  SendFleetVC.swift
//  OGame
//
//  Created by Subvert on 14.01.2022.
//

import UIKit

// MARK: - TODO: Refactor this VC -

protocol ISendFleetView: AnyObject {
    func showResourcesLoading(_ state: Bool)
    func updateResources(with: Resources)
    func showFleetSendLoading(_ state: Bool)
    func updateFleetSend(with: [Int: Bool])
    func showAlert(error: OGError)
}

final class SendFleetVC: BaseViewController {
    
    // MARK: Properties
    private var player: PlayerData
    private var ships: [Building]
    private var targetData: CheckTarget
    private var targetCoordinates: Coordinates
    private var presenter: SendFleetPresenter!
    
    private let sendFleetProvider = SendFleetProvider() // todo REMOVE it
 
    private var targetMission: Mission?
    private var briefingData: [String]?
    private var orders: [Int: Bool] = [:]
    private var missionTypeModel = MissionTypeModel()
    private var resourcesToSend = [0, 0, 0]
    private var fleetSpeed = 10
    
    private var myView: SendFleetView { return view as! SendFleetView }
    
    // MARK: View Lifecycle
    override func loadView() {
        view = SendFleetView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.sendFleet
        
        myView.tableView.delegate = self
        myView.tableView.dataSource = self
        
        presenter = SendFleetPresenter(view: self)
        presenter.loadResources(for: player)
        
        presenter.getInitialTarget(for: player, at: targetCoordinates, with: ships)
    }
    
    init(player: PlayerData, ships: [Building], target: CheckTarget) {
        self.player = player
        self.ships = ships
        self.targetData = target
        self.targetCoordinates = Coordinates(galaxy: targetData.targetPlanet!.galaxy,
                                             system: targetData.targetPlanet!.system,
                                             position: targetData.targetPlanet!.position,
                                             destination: .planet)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SendFleetView Delegate
extension SendFleetVC: ISendFleetView {
    func showResourcesLoading(_ state: Bool) {
        myView.showResourcesLoading(state)
    }
    
    func updateResources(with resources: Resources) {
        myView.updateResources(with: resources)
    }
    
    func showFleetSendLoading(_ state: Bool) {
        myView.showFleetSendLoading(state)
    }
    
    func updateFleetSend(with orders: [Int : Bool]) {
        // todo what the hell is that
        let coordinatesCell = myView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetCoordinatesCell
        coordinatesCell?.delegate = self
        
        let missionTypeCell = myView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MissionTypeCell
        let collectionView = missionTypeCell?.collectionView
        collectionView?.reloadData()
    }
    
    func showAlert(error: OGError) {
        logoutAndShowError(error)
    }
}

// MARK: - TableView Delegate & DataSource
extension SendFleetVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SetCoordinatesCellDelegate, FleetSettingsCellDelegate {
    
    
    // MARK: - Coordinates Button Pressed
    func didPressButton(_ sender: UIButton) {
        myView.showFleetSendLoading(true)
        Task {
            do {
                switch sender.tag {
                case 1:
                    targetCoordinates.destination = .planet
                case 2:
                    targetCoordinates.destination = .moon
                case 3:
                    targetCoordinates.destination = .debris
                default:
                    return
                }
                
                targetData = try await sendFleetProvider.checkTarget(player: player, whereTo: targetCoordinates, ships: ships)
                
                switch targetData.status {
                case "failure":
                    let falses = Array(repeating: false, count: 10)
                    for index in 0...9 {
                        orders[index] = falses[index]
                    }
                    let cell = myView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MissionTypeCell
                    let collectionView = cell.collectionView
                    collectionView!.reloadData()
                    
                    myView.showFleetSendLoading(false)
                    
                    let alert = UIAlertController(title: "\(targetData.errors![0].message)", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: K.ActionTitle.ok, style: .default))
                    present(alert, animated: true)
                    
                case "success":
                    if targetData.targetInhabited == true {
                        for order in targetData.orders! {
                            let orderKeyInt = Int(order.key)! - 1
                            if orderKeyInt != 15 {
                                orders[orderKeyInt] = order.value
                            } else {
                                orders[9] = order.value
                            }
                        }
                    } else {
                        if targetData.orders!["7"] == true {
                            let falses = Array(repeating: false, count: 10)
                            for index in 0...9 {
                                orders[index] = falses[index]
                            }
                            orders[6] = true
                        } else {
                            let falses = Array(repeating: false, count: 10)
                            for index in 0...9 {
                                orders[index] = falses[index]
                            }
                        }
                    }
                    
                    let rowsIndexPaths = [IndexPath(row: 0, section: 1),
                                          IndexPath(row: 0, section: 2)]
                    myView.tableView.reloadRows(at: rowsIndexPaths, with: .automatic)
                    
                    myView.showFleetSendLoading(false)
                    
                default:
                    break
                }
            } catch {
                throw OGError(message: "Error checking target galaxy", detailed: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Send Button Pressed
    func sendButtonPressed(_ sender: UIButton) {
        guard let targetMission = targetMission else { return }
        
        Task {
            do {
                myView.showFleetSendLoading(true)
                let response = try await sendFleetProvider.sendFleet(player: player,
                                                               mission: targetMission,
                                                               whereTo: targetCoordinates,
                                                               ships: ships,
                                                               resources: resourcesToSend,
                                                               speed: fleetSpeed)
                myView.showFleetSendLoading(false)
                if response.success {
                    let alert = UIAlertController(title: K.ActionTitle.success, message: response.message ?? "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: K.ActionTitle.ok, style: .default) { _ in
                        // TODO: Go back to menu
                    })
                    present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: K.ActionTitle.failure, message: response.errors?[0].message ?? "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: K.ActionTitle.ok, style: .default) { _ in
                        // TODO: Go back to menu or not?
                    })
                    present(alert, animated: true)
                }
            } catch {
                logoutAndShowError(error as! OGError)
            }
        }
    }
    
    // MARK: - NumberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - NumberOFSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: - TitleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Setting coordinates"
        case 1:
            return "Type of mission"
        case 2:
            return "Briefing"
        case 3:
            return "Send fleet"
        default:
            return "Error"
        }
    }
    
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.setCoordinatesCell, for: indexPath) as! SetCoordinatesCell
            cell.planetNameLabel.text = player.planet
            
            if player.moonIDs.contains(player.planetID) {
                cell.planetImage.image = UIImage(named: "planetUnavailable")
                cell.moonImage.image = UIImage(named: "moonAvailable")
            }
            
            cell.galaxyCoordinateTextField.delegate = self
            cell.systemCoordinateTextField.delegate = self
            cell.destinationCoordinateTextField.delegate = self
            
            cell.galaxyCoordinateTextField.text = String(player.celestials[player.currentPlanetIndex].coordinates[0])
            cell.systemCoordinateTextField.text = String(player.celestials[player.currentPlanetIndex].coordinates[1])
            cell.destinationCoordinateTextField.text = String(player.celestials[player.currentPlanetIndex].coordinates[2])
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.missionTypeCell, for: indexPath) as! MissionTypeCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.register(UINib(nibName: K.CellReuseID.CVMissionTypeCell, bundle: nil),
                                         forCellWithReuseIdentifier: K.CellReuseID.CVMissionTypeCell)
            cell.collectionView.reloadData()
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.missionBriefingCell, for: indexPath) as! MissionBriefingCell
            if targetData.targetPlanet == nil {
                let galaxy = "\(targetCoordinates.galaxy)"
                let system = "\(targetCoordinates.system)"
                let position = "\(targetCoordinates.position)"
                cell.targetLabel.text = "[\(galaxy):\(system):\(position)] No planet"
                return cell
            }
            let galaxy = "\(targetData.targetPlanet!.galaxy)"
            let system = "\(targetData.targetPlanet!.system)"
            let position = "\(targetData.targetPlanet!.position)"
            let name = "\(targetData.targetPlanet!.name)"
            cell.targetLabel.text = "[\(galaxy):\(system):\(position)] \(name) (\(targetData.targetPlayerName ?? ""))"
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.CellReuseID.fleetSettingsCell, for: indexPath) as! FleetSettingsCell
            cell.delegate = self
            cell.metalTextField.delegate = self
            cell.crystalTextField.delegate = self
            cell.deuteriumTextField.delegate = self
            cell.speedTextField.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // // MARK: - DidSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - TextFieldDidEndEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        myView.showFleetSendLoading(true)

        switch textField.tag {
        case 0, 1, 2:
            if textField.text == "0" || textField.text == "" {
                textField.text = "\(targetCoordinates.galaxy)"
            }
            
            switch textField.tag {
            case 0:
                targetCoordinates.galaxy = Int(textField.text!) ?? targetCoordinates.galaxy
            case 1:
                targetCoordinates.system = Int(textField.text!) ?? targetCoordinates.system
            case 2:
                targetCoordinates.position = Int(textField.text!) ?? targetCoordinates.position
            default:
                break
            }
            
            Task {
                do {
                    targetData = try await sendFleetProvider.checkTarget(player: player, whereTo: targetCoordinates, ships: ships)
                    if targetData.targetInhabited == true {
                        for order in targetData.orders! {
                            let orderKeyInt = Int(order.key)! - 1
                            if orderKeyInt != 15 {
                                orders[orderKeyInt] = order.value
                            } else {
                                orders[9] = order.value
                            }
                        }
                    } else {
                        if targetData.orders?["7"] == true {
                            let falses = Array(repeating: false, count: 10)
                            for index in 0...9 {
                                orders[index] = falses[index]
                            }
                            orders[6] = true
                        } else {
                            let falses = Array(repeating: false, count: 10)
                            for index in 0...9 {
                                orders[index] = falses[index]
                            }
                        }
                    }
                    
                    let rowsIndexPaths = [IndexPath(row: 0, section: 1),
                                          IndexPath(row: 0, section: 2)]
                    myView.tableView.reloadRows(at: rowsIndexPaths, with: .automatic)
                    myView.showFleetSendLoading(false)
                    
                } catch {
                    throw OGError(message: "Error checking target", detailed: error.localizedDescription)
                }
            }
        case 3, 4, 5, 6:
            if textField.text == "" {
                textField.text = "0"
            }
            
            switch textField.tag {
            case 3:
                resourcesToSend[0] = Int(textField.text!) ?? 0
            case 4:
                resourcesToSend[1] = Int(textField.text!) ?? 0
            case 5:
                resourcesToSend[2] = Int(textField.text!) ?? 0
            case 6:
                fleetSpeed = Int(textField.text!)! // TODO: Round to nearest 10 (0-100)
            default:
                break
            }
            let cell = myView.tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? FleetSettingsCell
            let resourcesTotal = resourcesToSend[0] + resourcesToSend[1] + resourcesToSend[2]
            cell?.cargoLabel.text = "\(resourcesTotal)/?" // TODO: Add full cargo number
            myView.showFleetSendLoading(false)
            
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        switch textField.tag {
        case 0:
            maxLength = 1
        case 1:
            maxLength = 3
        case 2:
            maxLength = 2
        default:
            maxLength = 12
        }
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let startPosition = textField.beginningOfDocument
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: startPosition, to: endPosition)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension SendFleetVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellReuseID.CVMissionTypeCell, for: indexPath) as! CVMissionTypeCell
        cell.isAvailable = false
        cell.missionTypeLabel.text = missionTypeModel.missionTypes[indexPath.row].name

        if !orders.isEmpty {
            if orders[indexPath.row] == true {
                cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.available
                cell.isAvailable = true
            } else {
                cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.unavailable
            }
        } else {
            cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.unavailable
        }
        
        let myCoords = [targetCoordinates.galaxy,
                        targetCoordinates.system,
                        targetCoordinates.position,
                        targetCoordinates.destination.rawValue]
        if myCoords == player.celestials[player.currentPlanetIndex].coordinates {
            cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.unavailable
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CVMissionTypeCell
        
        let myCoords = [targetCoordinates.galaxy,
                        targetCoordinates.system,
                        targetCoordinates.position,
                        targetCoordinates.destination.rawValue]
        let isSamePlanet = myCoords == player.celestials[player.currentPlanetIndex].coordinates
        
        if !cell.isActive && !cell.isAvailable { // not selected, not available
            cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.unavailableSelected
            cell.isActive = true
            targetMission = missionTypeModel.missionTypes[indexPath.row].type
            
        } else if !cell.isActive && cell.isAvailable { // not selected, available
            if !isSamePlanet {
                cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.availableSelected
                cell.isActive = true
                targetMission = missionTypeModel.missionTypes[indexPath.row].type
            } else {
                cell.missionTypeImageView.image = missionTypeModel.missionTypes[indexPath.row].images.unavailableSelected
                targetMission = missionTypeModel.missionTypes[indexPath.row].type
            }
        }
        
        for (index, mission) in missionTypeModel.missionTypes.enumerated() {
            let cellForChange = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! CVMissionTypeCell
            if mission.name != (cell.missionTypeLabel.text)! {
                cellForChange.isActive = false
                cellForChange.missionTypeImageView.image = missionTypeModel.missionTypes[index].images.unavailable
                if cellForChange.isAvailable {
                    if !isSamePlanet {
                        cellForChange.missionTypeImageView.image = missionTypeModel.missionTypes[index].images.available
                    } else {
                        cellForChange.missionTypeImageView.image = missionTypeModel.missionTypes[index].images.unavailable
                    }
                }
            }
        }
    }
}
