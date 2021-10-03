//
//  Slot.swift
//  OGame
//
//  Created by Subvert on 19.07.2021.
//

import Foundation

struct Slot {
    let total: Int
    let free: Int
    let used: Int

    init(with array: [Int]) {
        self.total = array[1]
        self.free = array[1] - array[0]
        self.used = array[0]
    }
}
