//
//  SendTarget.swift
//  OGame
//
//  Created by Subvert on 25.01.2022.
//

import Foundation

struct SendTarget: Codable {
    let success: Bool
    let message: String?
    let redirectURL: String?
    let errors: [SendTargetError]?
    let token: String
    let components: [String]
    let newAjaxToken: String
}

struct SendTargetError: Codable {
    let message: String
    let error: Int
}
