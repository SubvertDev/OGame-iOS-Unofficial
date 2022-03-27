//
//  LoginResponse.swift
//  OGame
//
//  Created by Subvert on 16.05.2021.
//

import Foundation

struct LoginResponse: Codable {
    let hasUnmigratedGameAccounts: Bool
    let isGameAccountCreated: Bool
    let isGameAccountMigrated: Bool
    let isPlatformLogin: Bool
    let platformUserId: String
    let token: String
}
