//
//  LoginData.swift
//  OGame
//
//  Created by Subvert on 06.03.2022.
//

import Foundation

struct LoginData: Codable {
    let identity: String
    let password: String
    let locale: String
    let gfLang: String
    let platformGameId: String
    let gameEnvironmentId: String
    let autoGameAccountCreation: Bool
}
