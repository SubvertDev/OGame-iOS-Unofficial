//
//  Typealiases.swift
//  OGame
//
//  Created by Subvert on 13.07.2021.
//

import UIKit

typealias BuildingWithLevelData = (name: String,
                                    metal: Int,
                                    crystal: Int,
                                    deuterium: Int,
                                    image: (available: UIImage?,
                                            unavailable: UIImage?,
                                            disabled: UIImage?),
                                    buildingsID: Int,
                                    level: Int,
                                    condition: String)

typealias BuildingWithAmountData = (name: String,
                                     metal: Int,
                                     crystal: Int,
                                     deuterium: Int,
                                     image: (available: UIImage?,
                                             unavailable: UIImage?,
                                             disabled: UIImage?),
                                     buildingsID: Int,
                                     amount: Int,
                                     condition: String)
