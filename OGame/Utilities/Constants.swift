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
    
    struct CellReuseID {
        static let menuCell = "MenuCell"
        static let overviewCell = "OverviewCell"
    }
}
