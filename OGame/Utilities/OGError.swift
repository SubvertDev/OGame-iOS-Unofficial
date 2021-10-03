//
//  OGError.swift
//  OGame
//
//  Created by Subvert on 02.10.2021.
//

import Foundation

struct OGError: Error {
    let message: String
    let detailed: String

    init(message: String, detailed: String) {
        self.message = message
        self.detailed = detailed
    }
}
