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

    var systemInfo: [Position?]?

    override func viewDidLoad() {
        super.viewDidLoad()

        galaxyTextField.text = "1"
        systemTextField.text = "1"

        tableView.register(UINib(nibName: "GalaxyCell", bundle: nil), forCellReuseIdentifier: "GalaxyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 88

        OGame.shared.getGalaxy(coordinates: [1, 1]) { result in
            switch result {
            case .success(let planets):
                self.systemInfo = planets
                DispatchQueue.main.async { self.tableView.reloadData() }
            case .failure(_):
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @IBAction func galaxyLeftPressed(_ sender: UIButton) {

    }

    @IBAction func galaxyRightPressed(_ sender: UIButton) {

    }

    @IBAction func systemLeftPressed(_ sender: UIButton) {

    }

    @IBAction func systemRightPressed(_ sender: UIButton) {

    }
}

extension GalaxyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellforrowat called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalaxyCell", for: indexPath) as! GalaxyCell
        guard let systemInfo = systemInfo else { return UITableViewCell() }
        print("cell dequeue")
        cell.planetPositionLabel.text = "\(indexPath.row + 1)"
        cell.planetNameLabel.text = "\(systemInfo[indexPath.row]?.planetName ?? "No Planet")"
        cell.playerNameLabel.text = "\(systemInfo[indexPath.row]?.playerName ?? "")"
        cell.allianceNameLabel.text = "\(systemInfo[indexPath.row]?.alliance ?? "")"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GalaxyVC: UITextFieldDelegate {

}
