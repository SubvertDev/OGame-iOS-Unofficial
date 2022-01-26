//
//  Images.swift
//  OGame
//
//  Created by Subvert on 27.05.2021.
//

import UIKit

typealias ImageBundle = (available: UIImage?,
                         unavailable: UIImage?,
                         disabled: UIImage?)

struct Images {
    struct Resources {
        struct Large {
            static let metalMine = UIImage(named: "metalMine")
            static let crystalMine = UIImage(named: "crystalMine")
            static let deuteriumMine = UIImage(named: "deuteriumSynthesizer")
            static let solarPlant = UIImage(named: "solarPlant")
            static let fusionPlant = UIImage(named: "fusionReactor")
            static let metalStorage = UIImage(named: "metalStorage")
            static let crystalStorage = UIImage(named: "crystalStorage")
            static let deuteriumStorage = UIImage(named: "deuteriumTank")
        }
        struct SmallAvailable {
            static let metalMine = UIImage(named: "metalMineAvailable")
            static let crystalMine = UIImage(named: "crystalMineAvailable")
            static let deuteriumMine = UIImage(named: "deuteriumMineAvailable")
            static let solarPlant = UIImage(named: "solarPlantAvailable")
            static let fusionPlant = UIImage(named: "fusionPlantAvailable")
            static let metalStorage = UIImage(named: "metalStorageAvailable")
            static let crystalStorage = UIImage(named: "crystalStorageAvailable")
            static let deuteriumStorage = UIImage(named: "deuteriumStorageAvailable")
        }
        struct SmallUnavailable {
            static let metalMine = UIImage(named: "metalMineUnavailable")
            static let crystalMine = UIImage(named: "crystalMineUnavailable")
            static let deuteriumMine = UIImage(named: "deuteriumMineUnavailable")
            static let solarPlant = UIImage(named: "solarPlantUnavailable")
            static let fusionPlant = UIImage(named: "fusionPlantUnavailable")
            static let metalStorage = UIImage(named: "metalStorageUnavailable")
            static let crystalStorage = UIImage(named: "crystalStorageUnavailable")
            static let deuteriumStorage = UIImage(named: "deuteriumStorageUnavailable")
        }
        struct SmallDisabled {
            static let metalMine = UIImage(named: "metalMineDisabled")
            static let crystalMine = UIImage(named: "crystalMineDisabled")
            static let deuteriumMine = UIImage(named: "deuteriumMineDisabled")
            static let solarPlant = UIImage(named: "solarPlantDisabled")
            static let fusionPlant = UIImage(named: "fusionPlantDisabled")
            static let metalStorage = UIImage(named: "metalStorageDisabled")
            static let crystalStorage = UIImage(named: "crystalStorageDisabled")
            static let deuteriumStorage = UIImage(named: "deuteriumStorageDisabled")
        }
    }

    struct Facilities {
        struct Large {
            static let roboticsFactory = UIImage(named: "roboticsFactory")
            static let shipyard = UIImage(named: "shipyard")
            static let researchLaboratory = UIImage(named: "researchLab")
            static let allianceDepot = UIImage(named: "allianceDepot")
            static let missileSilo = UIImage(named: "missileSilo")
            static let naniteFactory = UIImage(named: "naniteFactory")
            static let terraformer = UIImage(named: "terraformer")
            static let repairDock = UIImage(named: "spaceDock")
            static let moonBase = UIImage(named: "moonBase")
            static let sensorPhalanx = UIImage(named: "sensorPhalanx")
            static let jumpGate = UIImage(named: "jumpGate")
        }
        struct SmallAvailable {
            static let roboticsFactory = UIImage(named: "roboticsFactoryAvailable")
            static let shipyard = UIImage(named: "shipyardAvailable")
            static let researchLaboratory = UIImage(named: "researchLaboratoryAvailable")
            static let allianceDepot = UIImage(named: "allianceDepotAvailable")
            static let missileSilo = UIImage(named: "missileSiloAvailable")
            static let naniteFactory = UIImage(named: "naniteFactoryAvailable")
            static let terraformer = UIImage(named: "terraformerAvailable")
            static let repairDock = UIImage(named: "repairDockAvailable")
            static let moonBase = UIImage(named: "moonBaseAvailable")
            static let sensorPhalanx = UIImage(named: "sensorPhalanxAvailable")
            static let jumpGate = UIImage(named: "jumpGateAvailable")
        }
        struct SmallUnavailable {
            static let roboticsFactory = UIImage(named: "roboticsFactoryUnavailable")
            static let shipyard = UIImage(named: "shipyardUnavailable")
            static let researchLaboratory = UIImage(named: "researchLaboratoryUnavailable")
            static let allianceDepot = UIImage(named: "allianceDepotUnavailable")
            static let missileSilo = UIImage(named: "missileSiloUnavailable")
            static let naniteFactory = UIImage(named: "naniteFactoryUnavailable")
            static let terraformer = UIImage(named: "terraformerUnavailable")
            static let repairDock = UIImage(named: "repairDockUnavailable")
            static let moonBase = UIImage(named: "moonBaseUnavailable")
            static let sensorPhalanx = UIImage(named: "sensorPhalanxUnavailable")
            static let jumpGate = UIImage(named: "jumpGateUnavailable")
        }
        struct SmallDisabled {
            static let roboticsFactory = UIImage(named: "roboticsFactoryDisabled")
            static let shipyard = UIImage(named: "shipyardDisabled")
            static let researchLaboratory = UIImage(named: "researchLaboratoryDisabled")
            static let allianceDepot = UIImage(named: "allianceDepotDisabled")
            static let missileSilo = UIImage(named: "missileSiloDisabled")
            static let naniteFactory = UIImage(named: "naniteFactoryDisabled")
            static let terraformer = UIImage(named: "terraformerDisabled")
            static let repairDock = UIImage(named: "repairDockDisabled")
            static let moonBase = UIImage(named: "moonBaseDisabled")
            static let sensorPhalanx = UIImage(named: "sensorPhalanxDisabled")
            static let jumpGate = UIImage(named: "jumpGateDisabled")
        }
    }

    struct Researches {
        struct Large {
            static let energy = UIImage(named: "energyTechnology")
            static let laser = UIImage(named: "laserTechnology")
            static let ion = UIImage(named: "ionTechnology")
            static let hyperspace = UIImage(named: "hyperspaceTechnology")
            static let plasma = UIImage(named: "plasmaTechnology")
            static let combustionDrive = UIImage(named: "combustionDrive")
            static let impulseDrive = UIImage(named: "impulseDrive")
            static let hyperspaceDrive = UIImage(named: "hyperspaceDrive")
            static let espionage = UIImage(named: "espionageTechnology")
            static let computer = UIImage(named: "computerTechnology")
            static let astrophysics = UIImage(named: "astrophysics")
            static let researchNetwork = UIImage(named: "intergalacticResearchNetwork")
            static let graviton = UIImage(named: "gravitonTechnology")
            static let weapons = UIImage(named: "weaponsTechnology")
            static let shielding = UIImage(named: "shieldingTechnology")
            static let armour = UIImage(named: "armourTechnology")
        }
        struct SmallAvailable {
            static let energy = UIImage(named: "energyAvailable")
            static let laser = UIImage(named: "laserAvailable")
            static let ion = UIImage(named: "ionAvailable")
            static let hyperspace = UIImage(named: "hyperspaceAvailable")
            static let plasma = UIImage(named: "plasmaAvailable")
            static let combustionDrive = UIImage(named: "combustionDriveAvailable")
            static let impulseDrive = UIImage(named: "impulseDriveAvailable")
            static let hyperspaceDrive = UIImage(named: "hyperspaceDriveAvailable")
            static let espionage = UIImage(named: "espionageAvailable")
            static let computer = UIImage(named: "computerAvailable")
            static let astrophysics = UIImage(named: "astrophysicsAvailable")
            static let researchNetwork = UIImage(named: "researchNetworkAvailable")
            static let graviton = UIImage(named: "gravitonAvailable")
            static let weapons = UIImage(named: "weaponsAvailable")
            static let shielding = UIImage(named: "shieldingAvailable")
            static let armour = UIImage(named: "armourAvailable")
        }
        struct SmallUnavailable {
            static let energy = UIImage(named: "energyUnavailable")
            static let laser = UIImage(named: "laserUnavailable")
            static let ion = UIImage(named: "ionUnavailable")
            static let hyperspace = UIImage(named: "hyperspaceUnavailable")
            static let plasma = UIImage(named: "plasmaUnavailable")
            static let combustionDrive = UIImage(named: "combustionDriveUnavailable")
            static let impulseDrive = UIImage(named: "impulseDriveUnavailable")
            static let hyperspaceDrive = UIImage(named: "hyperspaceDriveUnavailable")
            static let espionage = UIImage(named: "espionageUnavailable")
            static let computer = UIImage(named: "computerUnavailable")
            static let astrophysics = UIImage(named: "astrophysicsUnavailable")
            static let researchNetwork = UIImage(named: "researchNetworkUnavailable")
            static let graviton = UIImage(named: "gravitonUnavailable")
            static let weapons = UIImage(named: "weaponsUnavailable")
            static let shielding = UIImage(named: "shieldingUnavailable")
            static let armour = UIImage(named: "armourUnavailable")
        }
        struct SmallDisabled {
            static let energy = UIImage(named: "energyDisabled")
            static let laser = UIImage(named: "laserDisabled")
            static let ion = UIImage(named: "ionDisabled")
            static let hyperspace = UIImage(named: "hyperspaceDisabled")
            static let plasma = UIImage(named: "plasmaDisabled")
            static let combustionDrive = UIImage(named: "combustionDriveDisabled")
            static let impulseDrive = UIImage(named: "impulseDriveDisabled")
            static let hyperspaceDrive = UIImage(named: "hyperspaceDriveDisabled")
            static let espionage = UIImage(named: "espionageDisabled")
            static let computer = UIImage(named: "computerDisabled")
            static let astrophysics = UIImage(named: "astrophysicsDisabled")
            static let researchNetwork = UIImage(named: "researchNetworkDisabled")
            static let graviton = UIImage(named: "gravitonDisabled")
            static let weapons = UIImage(named: "weaponsDisabled")
            static let shielding = UIImage(named: "shieldingDisabled")
            static let armour = UIImage(named: "armourDisabled")
        }
    }

    struct Ships {
        struct Large {
            static let lightFighter = UIImage(named: "lightFighter")
            static let heavyFighter = UIImage(named: "heavyFighter")
            static let cruiser = UIImage(named: "cruiser")
            static let battleship = UIImage(named: "battleship")
            static let battlecruiser = UIImage(named: "battlecruiser")
            static let bomber = UIImage(named: "bomber")
            static let destroyer = UIImage(named: "destroyer")
            static let deathstar = UIImage(named: "deathstar")
            static let reaper = UIImage(named: "reaper")
            static let pathfinder = UIImage(named: "pathfinder")
            static let smallCargo = UIImage(named: "smallCargo")
            static let largeCargo = UIImage(named: "largeCargo")
            static let colonyShip = UIImage(named: "colonyShip")
            static let recycler = UIImage(named: "recycler")
            static let espionageProbe = UIImage(named: "espionageProbe")
            static let solarSatellite = UIImage(named: "solarSatellite")
            static let crawler = UIImage(named: "crawler")
        }
        struct SmallAvailable {
            static let lightFighter = UIImage(named: "lightFighterAvailable")
            static let heavyFighter = UIImage(named: "heavyFighterAvailable")
            static let cruiser = UIImage(named: "cruiserAvailable")
            static let battleship = UIImage(named: "battleshipAvailable")
            static let battlecruiser = UIImage(named: "battlecruiserAvailable")
            static let bomber = UIImage(named: "bomberAvailable")
            static let destroyer = UIImage(named: "destroyerAvailable")
            static let deathstar = UIImage(named: "deathstarAvailable")
            static let reaper = UIImage(named: "reaperAvailable")
            static let pathfinder = UIImage(named: "pathfinderAvailable")
            static let smallCargo = UIImage(named: "smallCargoAvailable")
            static let largeCargo = UIImage(named: "largeCargoAvailable")
            static let colonyShip = UIImage(named: "colonyShipAvailable")
            static let recycler = UIImage(named: "recyclerAvailable")
            static let espionageProbe = UIImage(named: "espionageProbeAvailable")
            static let solarSatellite = UIImage(named: "solarSatelliteAvailable")
            static let crawler = UIImage(named: "crawlerAvailable")
        }
        struct SmallUnavailable {
            static let lightFighter = UIImage(named: "lightFighterUnavailable")
            static let heavyFighter = UIImage(named: "heavyFighterUnavailable")
            static let cruiser = UIImage(named: "cruiserUnavailable")
            static let battleship = UIImage(named: "battleshipUnavailable")
            static let battlecruiser = UIImage(named: "battlecruiserUnavailable")
            static let bomber = UIImage(named: "bomberUnavailable")
            static let destroyer = UIImage(named: "destroyerUnavailable")
            static let deathstar = UIImage(named: "deathstarUnavailable")
            static let reaper = UIImage(named: "reaperUnavailable")
            static let pathfinder = UIImage(named: "pathfinderUnavailable")
            static let smallCargo = UIImage(named: "smallCargoUnavailable")
            static let largeCargo = UIImage(named: "largeCargoUnavailable")
            static let colonyShip = UIImage(named: "colonyShipUnavailable")
            static let recycler = UIImage(named: "recyclerUnavailable")
            static let espionageProbe = UIImage(named: "espionageProbeUnavailable")
            static let solarSatellite = UIImage(named: "solarSatelliteUnavailable")
            static let crawler = UIImage(named: "crawlerUnavailable")
        }
        struct SmallDisabled {
            static let lightFighter = UIImage(named: "lightFighterDisabled")
            static let heavyFighter = UIImage(named: "heavyFighterDisabled")
            static let cruiser = UIImage(named: "cruiserDisabled")
            static let battleship = UIImage(named: "battleshipDisabled")
            static let battlecruiser = UIImage(named: "battlecruiserDisabled")
            static let bomber = UIImage(named: "bomberDisabled")
            static let destroyer = UIImage(named: "destroyerDisabled")
            static let deathstar = UIImage(named: "deathstarDisabled")
            static let reaper = UIImage(named: "reaperDisabled")
            static let pathfinder = UIImage(named: "pathfinderDisabled")
            static let smallCargo = UIImage(named: "smallCargoDisabled")
            static let largeCargo = UIImage(named: "largeCargoDisabled")
            static let colonyShip = UIImage(named: "colonyShipDisabled")
            static let recycler = UIImage(named: "recyclerDisabled")
            static let espionageProbe = UIImage(named: "espionageProbeDisabled")
            static let solarSatellite = UIImage(named: "solarSatelliteDisabled")
            static let crawler = UIImage(named: "crawlerDisabled")
        }
    }

    struct Defences {
        struct Large {
            static let rocketLauncher = UIImage(named: "rocketLauncher")
            static let lightLaser = UIImage(named: "lightLaser")
            static let heavyLaser = UIImage(named: "heavyLaser")
            static let gaussCannon = UIImage(named: "gaussCannon")
            static let ionCannon = UIImage(named: "ionCannon")
            static let plasmaCannon = UIImage(named: "plasmaCannon")
            static let smallShieldDome = UIImage(named: "smallShieldDome")
            static let largeShieldDome = UIImage(named: "largeShieldDome")
            static let antiBallisticMissiles = UIImage(named: "antiBallisticMissiles")
            static let interplanetaryMissiles = UIImage(named: "interplanetaryMissiles")
        }
        struct SmallAvailable {
            static let rocketLauncher = UIImage(named: "rocketLauncherAvailable")
            static let lightLaser = UIImage(named: "lightLaserAvailable")
            static let heavyLaser = UIImage(named: "heavyLaserAvailable")
            static let gaussCannon = UIImage(named: "gaussCannonAvailable")
            static let ionCannon = UIImage(named: "ionCannonAvailable")
            static let plasmaCannon = UIImage(named: "plasmaCannonAvailable")
            static let smallShieldDome = UIImage(named: "smallShieldDomeAvailable")
            static let largeShieldDome = UIImage(named: "largeShieldDomeAvailable")
            static let antiBallisticMissiles = UIImage(named: "antiBallisticMissilesAvailable")
            static let interplanetaryMissiles = UIImage(named: "interplanetaryMissilesAvailable")
        }
        struct SmallUnavailable {
            static let rocketLauncher = UIImage(named: "rocketLauncherUnavailable")
            static let lightLaser = UIImage(named: "lightLaserUnavailable")
            static let heavyLaser = UIImage(named: "heavyLaserUnavailable")
            static let gaussCannon = UIImage(named: "gaussCannonUnavailable")
            static let ionCannon = UIImage(named: "ionCannonUnavailable")
            static let plasmaCannon = UIImage(named: "plasmaCannonUnavailable")
            static let smallShieldDome = UIImage(named: "smallShieldDomeUnavailable")
            static let largeShieldDome = UIImage(named: "largeShieldDomeUnavailable")
            static let antiBallisticMissiles = UIImage(named: "antiBallisticMissilesUnavailable")
            static let interplanetaryMissiles = UIImage(named: "interplanetaryMissilesUnavailable")
        }
        struct SmallDisabled {
            static let rocketLauncher = UIImage(named: "rocketLauncherDisabled")
            static let lightLaser = UIImage(named: "lightLaserDisabled")
            static let heavyLaser = UIImage(named: "heavyLaserDisabled")
            static let gaussCannon = UIImage(named: "gaussCannonDisabled")
            static let ionCannon = UIImage(named: "ionCannonDisabled")
            static let plasmaCannon = UIImage(named: "plasmaCannonDisabled")
            static let smallShieldDome = UIImage(named: "smallShieldDomeDisabled")
            static let largeShieldDome = UIImage(named: "largeShieldDomeDisabled")
            static let antiBallisticMissiles = UIImage(named: "antiBallisticMissilesDisabled")
            static let interplanetaryMissiles = UIImage(named: "interplanetaryMissilesDisabled")
        }
    }
    
    struct MissionTypes {
        struct Available {
            static let expedition = UIImage(named: "expeditionAvailable")
            static let colonisation = UIImage(named: "colonisationAvailable")
            static let recycle = UIImage(named: "recycleAvailable")
            static let transport = UIImage(named: "transportAvailable")
            static let deployment = UIImage(named: "deploymentAvailable")
            static let espionage = UIImage(named: "espionageAvailableM")
            static let acsDefend = UIImage(named: "acsDefendAvailable")
            static let attack = UIImage(named: "attackAvailable")
            static let acsAttack = UIImage(named: "acsAttackAvailable")
            static let moonDestruction = UIImage(named: "moonDestructionAvailable")
            static let jumpGate = UIImage(named: "jumpGateAvailableM")
            
            static let allImages = [expedition,
                                    colonisation,
                                    recycle,
                                    transport,
                                    deployment,
                                    espionage,
                                    acsDefend,
                                    attack,
                                    acsAttack,
                                    moonDestruction,
                                    jumpGate]
        }
        struct AvailableSelected {
            static let expedition = UIImage(named: "expeditionAvailableSelected")
            static let colonisation = UIImage(named: "colonisationAvailableSelected")
            static let recycle = UIImage(named: "recycleAvailableSelected")
            static let transport = UIImage(named: "transportAvailableSelected")
            static let deployment = UIImage(named: "deploymentAvailableSelected")
            static let espionage = UIImage(named: "espionageAvailableSelected")
            static let acsDefend = UIImage(named: "acsDefendAvailableSelected")
            static let attack = UIImage(named: "attackAvailableSelected")
            static let acsAttack = UIImage(named: "acsAttackAvailableSelected")
            static let moonDestruction = UIImage(named: "moonDestructionAvailableSelected")
            static let jumpGate = UIImage(named: "jumpGateAvailableSelected")
            
            static let allImages = [expedition,
                                    colonisation,
                                    recycle,
                                    transport,
                                    deployment,
                                    espionage,
                                    acsDefend,
                                    attack,
                                    acsAttack,
                                    moonDestruction,
                                    jumpGate]
        }
        struct Unavailable {
            static let expedition = UIImage(named: "expeditionUnavailable")
            static let colonisation = UIImage(named: "colonisationUnavailable")
            static let recycle = UIImage(named: "recycleUnavailable")
            static let transport = UIImage(named: "transportUnavailable")
            static let deployment = UIImage(named: "deploymentUnavailable")
            static let espionage = UIImage(named: "espionageUnavailableM")
            static let acsDefend = UIImage(named: "acsDefendUnavailable")
            static let attack = UIImage(named: "attackUnavailable")
            static let acsAttack = UIImage(named: "acsAttackUnavailable")
            static let moonDestruction = UIImage(named: "moonDestructionUnavailable")
            static let jumpGate = UIImage(named: "jumpGateUnavailableM")
            
            static let allImages = [expedition,
                                    colonisation,
                                    recycle,
                                    transport,
                                    deployment,
                                    espionage,
                                    acsDefend,
                                    attack,
                                    acsAttack,
                                    moonDestruction,
                                    jumpGate]
        }
        struct UnavailableSelected {
            static let expedition = UIImage(named: "expeditionUnavailableSelected")
            static let colonisation = UIImage(named: "colonisationUnavailableSelected")
            static let recycle = UIImage(named: "recycleUnavailableSelected")
            static let transport = UIImage(named: "transportUnavailableSelected")
            static let deployment = UIImage(named: "deploymentUnavailableSelected")
            static let espionage = UIImage(named: "espionageUnavailableSelected")
            static let acsDefend = UIImage(named: "acsDefendUnavailableSelected")
            static let attack = UIImage(named: "attackUnavailableSelected")
            static let acsAttack = UIImage(named: "acsAttackUnavailableSelected")
            static let moonDestruction = UIImage(named: "moonDestructionUnavailableSelected")
            static let jumpGate = UIImage(named: "jumpGateUnavailableSelected")
            
            static let allImages = [expedition,
                                    colonisation,
                                    recycle,
                                    transport,
                                    deployment,
                                    espionage,
                                    acsDefend,
                                    attack,
                                    acsAttack,
                                    moonDestruction,
                                    jumpGate]
        }
    }
}
