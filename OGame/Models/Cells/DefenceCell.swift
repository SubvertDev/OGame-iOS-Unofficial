//
//  DefenceCell.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

class DefenceCell {

    var defenceTechnologies: DefencesData

    init(with defences: Defences) {

        let rocketLauncher = (name: "Rocket Launcher",
                              metal: Price().get(technology: Buildings().rocketLauncher(), level: defences.rocketLauncher.amount)[0],
                              crystal: Price().get(technology: Buildings().rocketLauncher(), level: defences.rocketLauncher.amount)[1],
                              deuterium: Price().get(technology: Buildings().rocketLauncher(), level: defences.rocketLauncher.amount)[2],
                              image: (available: Images.Defences.SmallAvailable.rocketLauncher,
                                      unavailable: Images.Defences.SmallUnavailable.rocketLauncher,
                                      disabled: Images.Defences.SmallDisabled.rocketLauncher),
                              buildingsID: 401,
                              amount: defences.rocketLauncher.amount,
                              condition: defences.rocketLauncher.condition)

        let lightLaser = (name: "Light Laser",
                                metal: Price().get(technology: Buildings().lightLaser(), level: defences.lightLaser.amount)[0],
                                crystal: Price().get(technology: Buildings().lightLaser(), level: defences.lightLaser.amount)[1],
                                deuterium: Price().get(technology: Buildings().lightLaser(), level: defences.lightLaser.amount)[2],
                                image: (available: Images.Defences.SmallAvailable.lightLaser,
                                        unavailable: Images.Defences.SmallUnavailable.lightLaser,
                                        disabled: Images.Defences.SmallDisabled.lightLaser),
                                buildingsID: 402,
                                amount: defences.lightLaser.amount,
                                condition: defences.lightLaser.condition)

        let heavyLaser = (name: "Heavy Laser",
                                metal: Price().get(technology: Buildings().heavyLaser(), level: defences.heavyLaser.amount)[0],
                                crystal: Price().get(technology: Buildings().heavyLaser(), level: defences.heavyLaser.amount)[1],
                                deuterium: Price().get(technology: Buildings().heavyLaser(), level: defences.heavyLaser.amount)[2],
                                image: (available: Images.Defences.SmallAvailable.heavyLaser,
                                        unavailable: Images.Defences.SmallUnavailable.heavyLaser,
                                        disabled: Images.Defences.SmallDisabled.heavyLaser),
                                        buildingsID: 403,
                                        amount: defences.heavyLaser.amount,
                                        condition: defences.heavyLaser.condition)

        let gaussCannon = (name: "Gauss Cannon",
                           metal: Price().get(technology: Buildings().gaussCannon(), level: defences.gaussCannon.amount)[0],
                           crystal: Price().get(technology: Buildings().gaussCannon(), level: defences.gaussCannon.amount)[1],
                           deuterium: Price().get(technology: Buildings().gaussCannon(), level: defences.gaussCannon.amount)[2],
                           image: (available: Images.Defences.SmallAvailable.gaussCannon,
                                   unavailable: Images.Defences.SmallUnavailable.gaussCannon,
                                   disabled: Images.Defences.SmallDisabled.gaussCannon),
                           buildingsID: 404,
                           amount: defences.gaussCannon.amount,
                           condition: defences.gaussCannon.condition)

        let ionCannon = (name: "Ion Cannon",
                         metal: Price().get(technology: Buildings().ionCannon(), level: defences.ionCannon.amount)[0],
                         crystal: Price().get(technology: Buildings().ionCannon(), level: defences.ionCannon.amount)[1],
                         deuterium: Price().get(technology: Buildings().ionCannon(), level: defences.ionCannon.amount)[2],
                         image: (available: Images.Defences.SmallAvailable.ionCannon,
                                 unavailable: Images.Defences.SmallUnavailable.ionCannon,
                                 disabled: Images.Defences.SmallDisabled.ionCannon),
                         buildingsID: 405,
                         amount: defences.ionCannon.amount,
                         condition: defences.ionCannon.condition)

        let plasmaCannon = (name: "Plasma Cannon",
                            metal: Price().get(technology: Buildings().plasmaCannon(), level: defences.plasmaCannon.amount)[0],
                            crystal: Price().get(technology: Buildings().plasmaCannon(), level: defences.plasmaCannon.amount)[1],
                            deuterium: Price().get(technology: Buildings().plasmaCannon(), level: defences.plasmaCannon.amount)[2],
                            image: (available: Images.Defences.SmallAvailable.plasmaCannon,
                                    unavailable: Images.Defences.SmallUnavailable.plasmaCannon,
                                    disabled: Images.Defences.SmallDisabled.plasmaCannon),
                            buildingsID: 406,
                            amount: defences.plasmaCannon.amount,
                            condition: defences.plasmaCannon.condition)

        let smallShieldDome = (name: "Small Shield Dome",
                               metal: Price().get(technology: Buildings().smallShieldDome(), level: defences.smallShieldDome.amount)[0],
                               crystal: Price().get(technology: Buildings().smallShieldDome(), level: defences.smallShieldDome.amount)[1],
                               deuterium: Price().get(technology: Buildings().smallShieldDome(), level: defences.smallShieldDome.amount)[2],
                               image: (available: Images.Defences.SmallAvailable.smallShieldDome,
                                       unavailable: Images.Defences.SmallUnavailable.smallShieldDome,
                                       disabled: Images.Defences.SmallDisabled.smallShieldDome),
                               buildingsID: 407,
                               amount: defences.smallShieldDome.amount,
                               condition: defences.smallShieldDome.condition)

        let largeShieldDome = (name: "Large Shield Dome",
                               metal: Price().get(technology: Buildings().largeShieldDome(), level: defences.largeShieldDome.amount)[0],
                               crystal: Price().get(technology: Buildings().largeShieldDome(), level: defences.largeShieldDome.amount)[1],
                               deuterium: Price().get(technology: Buildings().largeShieldDome(), level: defences.largeShieldDome.amount)[2],
                               image: (available: Images.Defences.SmallAvailable.largeShieldDome,
                                       unavailable: Images.Defences.SmallUnavailable.largeShieldDome,
                                       disabled: Images.Defences.SmallDisabled.largeShieldDome),
                               buildingsID: 408,
                               amount: defences.largeShieldDome.amount,
                               condition: defences.largeShieldDome.condition)

        let antiBallisticMissiles = (name: "Anti-Ballistic Missiles",
                                  metal: Price().get(technology: Buildings().antiBallisticMissiles(), level: defences.antiBallisticMissiles.amount)[0],
                                  crystal: Price().get(technology: Buildings().antiBallisticMissiles(), level: defences.antiBallisticMissiles.amount)[1],
                                  deuterium: Price().get(technology: Buildings().antiBallisticMissiles(), level: defences.antiBallisticMissiles.amount)[2],
                                  image: (available: Images.Defences.SmallAvailable.antiBallisticMissiles,
                                          unavailable: Images.Defences.SmallUnavailable.antiBallisticMissiles,
                                          disabled: Images.Defences.SmallDisabled.antiBallisticMissiles),
                                  buildingsID: 502,
                                  amount: defences.antiBallisticMissiles.amount,
                                  condition: defences.antiBallisticMissiles.condition)

        let interplanetaryMissiles = (name: "Interplanetary Missiles",
                                     metal: Price().get(technology: Buildings().interplanetaryMissiles(), level: defences.interplanetaryMissiles.amount)[0],
                                     crystal: Price().get(technology: Buildings().interplanetaryMissiles(), level: defences.interplanetaryMissiles.amount)[1],
                                     deuterium: Price().get(technology: Buildings().interplanetaryMissiles(), level: defences.interplanetaryMissiles.amount)[2],
                                     image: (available: Images.Defences.SmallAvailable.interplanetaryMissiles,
                                             unavailable: Images.Defences.SmallUnavailable.interplanetaryMissiles,
                                             disabled: Images.Defences.SmallDisabled.interplanetaryMissiles),
                                     buildingsID: 503,
                                     amount: defences.interplanetaryMissiles.amount,
                                     condition: defences.interplanetaryMissiles.condition)

        defenceTechnologies = [rocketLauncher,
                               lightLaser,
                               heavyLaser,
                               gaussCannon,
                               ionCannon,
                               plasmaCannon,
                               smallShieldDome,
                               largeShieldDome,
                               antiBallisticMissiles,
                               interplanetaryMissiles]
    }
}
