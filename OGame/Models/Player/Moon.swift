//
//  Moon.swift
//  OGame
//
//  Created by Subvert on 26.02.2022.
//

import Foundation

struct Moon {
    let diameter: Int
    let used: Int
    let total: Int
    let free: Int
    var coordinates: [Int]

    init(moonSize: Int, usedFields: Int, totalFields: Int, coordinates: [Int]) {
        self.diameter = moonSize
        self.used = usedFields
        self.total = totalFields
        self.free = total - used
        self.coordinates = coordinates
    }
}
