//
//  Constants.swift
//  OGame
//
//  Created by Subvert on 3/28/22.
//

import Foundation

struct K {
    
    struct Titles {
        static let menu = "Menu"
        static let overview = "Overview"
        static let fleet = "Fleet"
        static let sendFleet = "Send Fleet"
        static let movement = "Movement"
        static let galaxy = "Galaxy"
        static let settings = "Settings"
    }
    
    struct Menu {
        static let cellTitlesList = ["Overview", "Resources", "Facilities",
                                     "Research", "Shipyard", "Defence",
                                     "Fleet", "Movement", "Galaxy", "Settings"]
    }
    
    struct Overview {
        struct Section {
            static let resourcesAndFacilities = "Resources & Facilities"
            static let researches = "Research"
            static let shipyardAndDefences = "Shipyard & Defences"
            static let error = "Section Error"
        }
    }
    
    struct Galaxy {
        struct Placeholder {
            static let galaxy = "Galaxy"
            static let system = "System"
        }
    }
    
    // MARK: -
    
    struct CellReuseID {
        static let serverCell = "ServerCell"
        static let menuCell = "MenuCell"
        static let overviewCell = "OverviewCell"
        static let buildingCell = "BuildingCell"
        static let galaxyCell = "GalaxyCell"
        static let sendFleetCell = "SendFleetCell"
        static let setCoordinatesCell = "SetCoordinatesCell"
        static let missionTypeCell = "MissionTypeCell"
        static let CVMissionTypeCell = "CVMissionTypeCell"
        static let missionBriefingCell = "MissionBriefingCell"
        static let fleetSettingsCell = "FleetSettingsCell"
        static let fleetCell = "FleetCell"
    }
    
    struct Segue {
        static let showServerListVC = "ShowServerListVC"
    }
    
    struct Defaults {
        static let username = "username"
        static let password = "password"
    }
    
    struct Error {
        static let error = "Error"
        static let ok = "OK"
        static let yes = "Yes"
        static let no = "No"
        static let cancel = "Cancel"
        static let success = "Success"
        static let failure = "Failure"
    }
}
