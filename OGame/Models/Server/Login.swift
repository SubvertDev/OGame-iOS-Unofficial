//
//  Login.swift
//  OGame
//
//  Created by Subvert on 16.05.2021.
//

import Foundation

struct Login: Codable {
    let hasUnmigratedGameAccounts: Bool
    let isGameAccountCreated: Bool
    let isGameAccountMigrated: Bool
    let isPlatformLogin: Bool
    let platformUserId: String
    let token: String
}

struct LoginData: Codable {
    let identity: String
    let password: String
    let locale: String
    let gfLang: String
    let platformGameId: String
    let gameEnvironmentId: String
    let autoGameAccountCreation: Bool
}
