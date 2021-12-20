//
//  Typealiases.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

typealias BuildingsData = [(name: String,
                            metal: Int,
                            crystal: Int,
                            deuterium: Int,
                            image: (available: UIImage?,
                                    unavailable: UIImage?,
                                    disabled: UIImage?),
                            buildingsID: Int,
                            level: Int,
                            condition: String)]

typealias BuildingData = (name: String,
                          metal: Int,
                          crystal: Int,
                          deuterium: Int,
                          image: (available: UIImage?,
                                  unavailable: UIImage?,
                                  disabled: UIImage?),
                          buildingsID: Int,
                          level: Int,
                          condition: String)

typealias ResearchesData = [(name: String,
                             metal: Int,
                             crystal: Int,
                             deuterium: Int,
                             image: (available: UIImage?,
                                     unavailable: UIImage?,
                                     disabled: UIImage?),
                             buildingsID: Int,
                             level: Int,
                             condition: String)]

typealias ShipsData = [(name: String,
                        metal: Int,
                        crystal: Int,
                        deuterium: Int,
                        image: (available: UIImage?,
                                unavailable: UIImage?,
                                disabled: UIImage?),
                        buildingsID: Int,
                        amount: Int,
                        condition: String)]

typealias DefencesData = [(name: String,
                           metal: Int,
                           crystal: Int,
                           deuterium: Int,
                           image: (available: UIImage?,
                                   unavailable: UIImage?,
                                   disabled: UIImage?),
                           buildingsID: Int,
                           amount: Int,
                           condition: String)]
