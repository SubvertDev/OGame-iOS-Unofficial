//
//  Constants.swift
//  OGame
//
//  Created by Subvert on 3/28/22.
//

import Foundation

struct K {
    
    static var debugMode = UserDefaults.standard.bool(forKey: "debugMode")
    
    struct Titles {
        static let menu = "Menu"
        static let overview = "Overview"
        static let fleet = "Fleet"
        static let sendFleet = "Send Fleet"
        static let movement = "Movement"
        static let galaxy = "Galaxy"
        static let settings = "Settings"
        static let rules = "Rules"
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
    
    struct ActionTitle {
        static let error = "Error"
        static let ok = "OK"
        static let yes = "Yes"
        static let no = "No"
        static let cancel = "Cancel"
        static let success = "Success"
        static let failure = "Failure"
    }
    
    struct Texts {
        static let rules = """
                        
                        The following points are valid for all the Universes listed at OGame.org.
                        
                        The rules have been established to allow all players to enjoy fair gameplay within their universes.
                        
                        Please note, that for data confidentiality reasons, complaints and inquiries regarding particular accounts will only be discussed with their owners.
                        
                        For the specific rules, or if you have any questions or are unsure about anything to do with the rules, you can read about it in the OGame forums.
                        
                        1. Accounts
                        The owner of a game account is the owner of the Lobby account where the game account is located.
                        Each account is entitled to be played by a single player at any time, account sitting being the only exception.
                        Game account exchanges to another user are only permitted using the ‘Account Gifting’ function within a Lobby account.
                        Lobby accounts cannot be transferred to others.
                        
                        2. Multi Account
                        Every player is allowed to control a single account per universe.
                        If two or more accounts are usually, occasionally, or permanently being played from the same network (e.g. schools, universities, internet cafés) it is highly recommended to notify a GameOperator in advance at http://support.en.ogame.gameforge.com.
                        
                        3. Account Sitting
                        ‘Account Sitting’ enables a player to allow another player to ‘sit’ their account, i.e. caretake it in their stead.
                        An account may be sat for a maximum of 48 hours.
                        Account sitting is only permitted using ‘Sitting Codes’, which are available in the Lobby. While the account is being sat, it cannot carry out battle activities with other players.
                        Lobby details cannot be passed on to other players. Any infringement on these rules may lead to a permanent ban for the Lobby account for account sharing.
                        
                        4. Bashing
                        You are not allowed to attack any given planet or moon owned by an active player more than 6 times in a 24-hour period. This rule also applies to moon destruction missions. Probe attacks and interplanetary missile attacks do not fall under the bashing rule. Exceptions are universes where active looting with probes is possible.
                        Bashing is only allowed when your alliance is at war with another alliance. The war must be announced in the relevant OGame forum and must comply with the forum-specific rules.
                        A bashing investigation will only proceed if a player is reported.
                        
                        5. Pushing
                        No account is allowed to obtain unfair profit from the resources of a lower ranked player. Pushing is defined as, but not only limited to, the following: resources sent from a lower-ranked account to a higher-ranked one with nothing tangible in return.
                        Setting up a battle to enable a higher-ranked account to obtain profit from a lower-ranked account or manipulating trade ratios for a higher-ranked account to gain an advantage through a lower ranked account are considered an unfair profit.
                        Trades, recycling help & ACS splits must be completed within 72 hours.
                        For all exceptions (bounties, etc.) a Game Operator should be informed via the Support system (https://ogame.support.gameforge.com/index.php?fld=en).
                        
                        6. Bugusing / Scripting
                        Using a bug for anyone`s profit intentionally or not reporting a bug intentionally is strictly forbidden. Using a programme as an interface between the player and the game is prohibited. Any other form of automatically generated information created for malicious misuse is forbidden as well. Exceptions are listed in the forum of the game.
                        
                        7. Real-life threats
                        Implying that you are going to locate and harm another player, team member, Gameforge representative, or any person that might be related in any way to any of the game services is forbidden.
                        
                        8. Insults and Spam
                        Any kind of insult and spam are not allowed.
                        
                        9. Language
                        The game’s publisher reserves the right to exclude players, who are not able to speak the game’s respective native language (e.g. in the game, forum or on the Discord server). Other permitted languages will be listed in the official game forum.
                        
                        10. Breach of the rules
                        Any kind of breach of the rules will be punished with warnings up to a permanent ban of the account. The corresponding GameOperators decide the type and duration of punishments and are contact persons for bans.
                        
                        11. Terms and Conditions
                        The terms and conditions are supplemented with these rules, and must be abided by at all times.
                        
                        12. Exceptions
                        The game`s community management reserves the right to have exceptions to these rules. In special cases (e.g. during events) game rules can be changed or suspended. The user group concerned will be informed when and if this is the case.
                        
                        13. Support
                        Contact our Support team for any problems you may have relating to the game.
                        Report issues as soon as you can, so we can offer you the best possible support. We can only provide support for issues which arose during the last 3 months.
                        """
    }
}
