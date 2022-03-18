//
//  Celestial.swift
//  OGame
//
//  Created by Subvert on 14.07.2021.
//

import Foundation

struct Celestial {
    let diameter: Int
    let used: Int
    let total: Int
    let free: Int
    let tempMin: Int
    let tempMax: Int
    var coordinates: [Int]
    let moon: Moon?

    init(planetSize: Int, usedFields: Int, totalFields: Int, tempMin: Int, tempMax: Int, coordinates: [Int], moon: Moon?) {
        self.diameter = planetSize
        self.used = usedFields
        self.total = totalFields
        self.free = total - used
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.coordinates = coordinates
        self.moon = moon
    }
}
