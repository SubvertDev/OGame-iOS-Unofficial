//
//  Constants.swift
//  OGame
//
//  Created by Subvert on 3/28/22.
//

import Foundation

struct K {
    
    struct Menu {
        static let title = "Menu"
        static let cellTitlesList = ["Overview", "Resources", "Facilities",
                                     "Research", "Shipyard", "Defence",
                                     "Fleet", "Movement", "Galaxy"]
    }
    
    struct Overview {
        static let title = "Overview"
        
        struct Section {
            static let resourcesAndFacilities = "Resources & Facilities"
            static let researches = "Research"
            static let shipyardAndDefences = "Shipyard & Defences"
            static let error = "Section Error"
        }
    }
    
    struct Fleet {
        static let title = "Fleet"
    }
    
    struct SendFleet {
        static let title = "Send Fleet"
    }
    
    struct Galaxy {
        static let title = "Galaxy"
        
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
    }
}