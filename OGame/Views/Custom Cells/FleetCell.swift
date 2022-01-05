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
    @IBOutlet weak var missionTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(with fleet: Fleets) {
        friendlyPlanetImage.image = fleet.playerPlanetImage
        enemyPlanetImage.image = fleet.enemyPlanetImage
        
        switch fleet.mission {
        case "Attacked":
            missionTypeLabel.text = "Attacked"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            enemyArrivalTimeLabel.text = " "
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)
            
            missionTypeImage.image = UIImage(systemName: "airplane")?.withHorizontallyFlippedOrientation()
            
            // TODO: Change it to an actual images?
            friendlyPlanetImage.image = UIImage(systemName: "shield.fill")
            enemyPlanetImage.image = UIImage(systemName: "bolt")
            
        case "Attack", "Attack (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)
            
            if fleet.mission == "Attack (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }

        case "Transport", "Transport (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            if fleet.mission == "Transport (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }

        case "Deployment", "Deployment (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = " "
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            missionTypeLabel.text = "\(fleet.mission)"

            if fleet.mission == "Deployment (R)" {
                enemyArrivalTimeLabel.text = " "
                friendlyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }

        case "Harvest", "Harvest (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = "Debris"
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            enemyPlanetImage.image = UIImage(systemName: "triangle")

            if fleet.mission == "Harvest (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }

        case "Expedition", "Expedition (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = "Deep Space"
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            enemyPlanetImage.image = UIImage(systemName: "questionmark.circle")

            if fleet.mission == "Expedition (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }

        // TODO: Colonisation, Espionage, ACS Defend, ACS Attack, Moon Destruction
            
        default:
            missionTypeLabel.text = "ERROR"
        }
    }

    func destinationToString(_ destination: [Int]) -> String {
        return "[\(destination[0]):\(destination[1]):\(destination[2])]"
    }
}
