//
//  FleetCell.swift
//  OGame
//
//  Created by Subvert on 04.10.2021.
//

import UIKit

class FleetCell: UITableViewCell {

    @IBOutlet weak var friendlyPlanetImage: UIImageView!
    @IBOutlet weak var enemyPlanetImage: UIImageView!
    @IBOutlet weak var friendlyPlanetNameLabel: UILabel!
    @IBOutlet weak var enemyPlanetNameLabel: UILabel!
    @IBOutlet weak var friendlyPlanetCoordinatesLabel: UILabel!
    @IBOutlet weak var enemyPlanetCoordinatesLabel: UILabel!
    @IBOutlet weak var friendlyArrivalTimeLabel: UILabel!
    @IBOutlet weak var enemyArrivalTimeLabel: UILabel!
    @IBOutlet weak var missionTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(with fleet: Fleets) {

        switch fleet.mission {
        case "Attacked":
            friendlyArrivalTimeLabel.text = " "
            friendlyPlanetNameLabel.text = fleet.enemyPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            enemyPlanetNameLabel.text = fleet.playerPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            missionTypeLabel.text = ">>> Attack >>>"

        case "Transport", "Transport (R)":
            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            if fleet.mission == "Transport (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeLabel.text = "<<< \(fleet.mission) <<<"
            } else {
                missionTypeLabel.text = ">>> \(fleet.mission) >>>"
            }

        case "Deployment", "Deployment (R)":
            friendlyArrivalTimeLabel.text = " "
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            missionTypeLabel.text = ">>> \(fleet.mission) >>>"

            if fleet.mission == "Deployment (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeLabel.text = "<<< \(fleet.mission) <<<"
            } else {
                missionTypeLabel.text = ">>> \(fleet.mission) >>>"
            }

        case "Harvest", "Harvest (R)":
            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = "Debris"
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            enemyPlanetImage.image = UIImage(systemName: "triangle")

            if fleet.mission == "Harvest (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeLabel.text = "<<< \(fleet.mission) <<<"
            } else {
                missionTypeLabel.text = ">>> \(fleet.mission) >>>"
            }

        case "Expedition", "Expedition (R)":
            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = "Deep Space"
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            enemyPlanetImage.image = UIImage(systemName: "questionmark.circle")

            if fleet.mission == "Expedition (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeLabel.text = "<<< \(fleet.mission) <<<"
            } else {
                missionTypeLabel.text = ">>> \(fleet.mission) >>>"
            }

        default:
            break
        }
    }

    func destinationToString(_ destination: [Int]) -> String {
        return "[\(destination[0]):\(destination[1]):\(destination[2])]"
    }
}
