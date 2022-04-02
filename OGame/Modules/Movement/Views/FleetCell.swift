//
//  FleetCell.swift
//  OGame
//
//  Created by Subvert on 04.10.2021.
//

import UIKit

final class FleetCell: UITableViewCell {

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
        selectionStyle = .none
    }

    func set(with fleet: Fleets) {
        friendlyPlanetImage.image = fleet.playerPlanetImage
        enemyPlanetImage.image = fleet.enemyPlanetImage
        
        switch fleet.mission {
        // MARK: - Attacked
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
            
        // MARK: - Attack
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
            
        // MARK: - Transport
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

        // MARK: - Deployment
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

        // MARK: - Harvest (Recycle)
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

        // MARK: - Expedition
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
            
        // MARK: - Espionage
        case "Espionage", "Espionage (R)":
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            if fleet.mission == "Espionage (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }
            
        // MARK: - Colonisation
        case "Colonisation", "Colonisation (R)": // TODO: TEST
            missionTypeLabel.text = "\(fleet.mission)"

            friendlyArrivalTimeLabel.text = String(fleet.arrivalTime).convertDateToString()
            friendlyPlanetNameLabel.text = fleet.playerPlanet
            friendlyPlanetCoordinatesLabel.text = destinationToString(fleet.origin)

            enemyArrivalTimeLabel.text = String(fleet.endTime!).convertDateToString()
            enemyPlanetNameLabel.text = fleet.enemyPlanet
            enemyPlanetCoordinatesLabel.text = destinationToString(fleet.destination)

            if fleet.mission == "Colonisation (R)" {
                enemyArrivalTimeLabel.text = " "
                missionTypeImage.transform = missionTypeImage.transform.rotated(by: .pi)
            }
            
        // MARK: TODO: ACS Defend, ACS Attack, Moon Destruction
            
        default:
            missionTypeLabel.text = "ERROR"
        }
    }

    private func destinationToString(_ destination: [Int]) -> String {
        return "[\(destination[0]):\(destination[1]):\(destination[2])]"
    }
}
