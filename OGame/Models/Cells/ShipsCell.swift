//
//  ShipsCell.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

struct ShipsCell {

    var shipsTechnologies: ShipsData

    init(with ships: Ships) {

        let lightFighter = (name: "Light Fighter",
                          metal: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[0],
                          crystal: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[1],
                          deuterium: Price().get(technology: Shipings().lightFighter(), level: ships.lightFighter.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.lightFighter,
                                  unavailable: Images.Ships.SmallUnavailable.lightFighter,
                                  disabled: Images.Ships.SmallDisabled.lightFighter),
                          buildingsID: 204,
                          amount: ships.lightFighter.amount,
                          condition: ships.lightFighter.condition)

        let heavyFighter = (name: "Heavy Fighter",
                          metal: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[0],
                          crystal: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[1],
                          deuterium: Price().get(technology: Shipings().heavyFighter(), level: ships.heavyFighter.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.heavyFighter,
                                  unavailable: Images.Ships.SmallUnavailable.heavyFighter,
                                  disabled: Images.Ships.SmallDisabled.heavyFighter),
                          buildingsID: 205,
                          amount: ships.heavyFighter.amount,
                          condition: ships.heavyFighter.condition)

        let cruiser = (name: "Cruiser",
                          metal: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[0],
                          crystal: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[1],
                          deuterium: Price().get(technology: Shipings().cruiser(), level: ships.cruiser.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.cruiser,
                                  unavailable: Images.Ships.SmallUnavailable.cruiser,
                                  disabled: Images.Ships.SmallDisabled.cruiser),
                          buildingsID: 206,
                          amount: ships.cruiser.amount,
                          condition: ships.cruiser.condition)

        let battleship = (name: "Battleship",
                          metal: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[0],
                          crystal: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[1],
                          deuterium: Price().get(technology: Shipings().battleship(), level: ships.battleship.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.battleship,
                                  unavailable: Images.Ships.SmallUnavailable.battleship,
                                  disabled: Images.Ships.SmallDisabled.battleship),
                          buildingsID: 207,
                          amount: ships.battleship.amount,
                          condition: ships.battleship.condition)

        let battlecruiser = (name: "Battlecruiser",
                          metal: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[0],
                          crystal: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[1],
                          deuterium: Price().get(technology: Shipings().battlecruiser(), level: ships.battlecruiser.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.battlecruiser,
                                  unavailable: Images.Ships.SmallUnavailable.battlecruiser,
                                  disabled: Images.Ships.SmallDisabled.battlecruiser),
                          buildingsID: 215,
                          amount: ships.battlecruiser.amount,
                          condition: ships.battlecruiser.condition)

        let bomber = (name: "Bomber",
                          metal: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[0],
                          crystal: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[1],
                          deuterium: Price().get(technology: Shipings().bomber(), level: ships.bomber.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.bomber,
                                  unavailable: Images.Ships.SmallUnavailable.bomber,
                                  disabled: Images.Ships.SmallDisabled.bomber),
                          buildingsID: 211,
                          amount: ships.bomber.amount,
                          condition: ships.bomber.condition)

        let destroyer = (name: "Destroyer",
                          metal: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[0],
                          crystal: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[1],
                          deuterium: Price().get(technology: Shipings().destroyer(), level: ships.destroyer.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.destroyer,
                                  unavailable: Images.Ships.SmallUnavailable.destroyer,
                                  disabled: Images.Ships.SmallDisabled.destroyer),
                          buildingsID: 213,
                          amount: ships.destroyer.amount,
                          condition: ships.destroyer.condition)

        let deathstar = (name: "Deathstar",
                          metal: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[0],
                          crystal: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[1],
                          deuterium: Price().get(technology: Shipings().deathstar(), level: ships.deathstar.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.deathstar,
                                  unavailable: Images.Ships.SmallUnavailable.deathstar,
                                  disabled: Images.Ships.SmallDisabled.deathstar),
                          buildingsID: 214,
                          amount: ships.deathstar.amount,
                          condition: ships.deathstar.condition)

        let reaper = (name: "Reaper",
                          metal: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[0],
                          crystal: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[1],
                          deuterium: Price().get(technology: Shipings().reaper(), level: ships.reaper.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.reaper,
                                  unavailable: Images.Ships.SmallUnavailable.reaper,
                                  disabled: Images.Ships.SmallDisabled.reaper),
                          buildingsID: 218,
                          amount: ships.reaper.amount,
                          condition: ships.reaper.condition)

        let pathfinder = (name: "Pathfinder",
                          metal: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[0],
                          crystal: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[1],
                          deuterium: Price().get(technology: Shipings().pathfinder(), level: ships.pathfinder.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.pathfinder,
                                  unavailable: Images.Ships.SmallUnavailable.pathfinder,
                                  disabled: Images.Ships.SmallDisabled.pathfinder),
                          buildingsID: 219,
                          amount: ships.pathfinder.amount,
                          condition: ships.pathfinder.condition)

        let smallCargo = (name: "Small Cargo",
                          metal: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[0],
                          crystal: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[1],
                          deuterium: Price().get(technology: Shipings().smallCargo(), level: ships.smallCargo.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.smallCargo,
                                  unavailable: Images.Ships.SmallUnavailable.smallCargo,
                                  disabled: Images.Ships.SmallDisabled.smallCargo),
                          buildingsID: 202,
                          amount: ships.smallCargo.amount,
                          condition: ships.smallCargo.condition)

        let largeCargo = (name: "Large Cargo",
                          metal: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[0],
                          crystal: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[1],
                          deuterium: Price().get(technology: Shipings().largeCargo(), level: ships.largeCargo.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.largeCargo,
                                  unavailable: Images.Ships.SmallUnavailable.largeCargo,
                                  disabled: Images.Ships.SmallDisabled.largeCargo),
                          buildingsID: 203,
                          amount: ships.largeCargo.amount,
                          condition: ships.largeCargo.condition)

        let colonyShip = (name: "Colony Ship",
                          metal: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[0],
                          crystal: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[1],
                          deuterium: Price().get(technology: Shipings().colonyShip(), level: ships.colonyShip.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.colonyShip,
                                  unavailable: Images.Ships.SmallUnavailable.colonyShip,
                                  disabled: Images.Ships.SmallDisabled.colonyShip),
                          buildingsID: 208,
                          amount: ships.colonyShip.amount,
                          condition: ships.colonyShip.condition)

        let recycler = (name: "Recycler",
                          metal: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[0],
                          crystal: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[1],
                          deuterium: Price().get(technology: Shipings().recycler(), level: ships.recycler.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.recycler,
                                  unavailable: Images.Ships.SmallUnavailable.recycler,
                                  disabled: Images.Ships.SmallDisabled.recycler),
                          buildingsID: 209,
                          amount: ships.recycler.amount,
                          condition: ships.recycler.condition)

        let espionageProbe = (name: "Espionage Probe",
                          metal: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[0],
                          crystal: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[1],
                          deuterium: Price().get(technology: Shipings().espionageProbe(), level: ships.espionageProbe.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.espionageProbe,
                                  unavailable: Images.Ships.SmallUnavailable.espionageProbe,
                                  disabled: Images.Ships.SmallDisabled.espionageProbe),
                          buildingsID: 210,
                          amount: ships.espionageProbe.amount,
                          condition: ships.espionageProbe.condition)

        let solarSatellite = (name: "Solar Satellite",
                          metal: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[0],
                          crystal: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[1],
                          deuterium: Price().get(technology: Shipings().solarSatellite(), level: ships.solarSatellite.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.solarSatellite,
                                  unavailable: Images.Ships.SmallUnavailable.solarSatellite,
                                  disabled: Images.Ships.SmallDisabled.solarSatellite),
                          buildingsID: 212,
                          amount: ships.solarSatellite.amount,
                          condition: ships.solarSatellite.condition)

        let crawler = (name: "Crawler",
                          metal: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[0],
                          crystal: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[1],
                          deuterium: Price().get(technology: Shipings().crawler(), level: ships.crawler.amount)[2],
                          image: (available: Images.Ships.SmallAvailable.crawler,
                                  unavailable: Images.Ships.SmallUnavailable.crawler,
                                  disabled: Images.Ships.SmallDisabled.crawler),
                          buildingsID: 217,
                          amount: ships.crawler.amount,
                          condition: ships.crawler.condition)

        shipsTechnologies = [lightFighter,
                             heavyFighter,
                             cruiser,
                             battleship,
                             battlecruiser,
                             bomber,
                             destroyer,
                             deathstar,
                             reaper,
                             pathfinder,
                             smallCargo,
                             largeCargo,
                             colonyShip,
                             recycler,
                             espionageProbe,
                             solarSatellite,
                             crawler]
    }
}
