//
//  Account.swift
//  OGame
//
//  Created by Subvert on 16.05.2021.
//

import Foundation

struct Account: Codable {
    let server: ServerInfo
    let id: Int
    let gameAccountId: Int
    let name: String
    // let lastPlayed: String?
    // let lastLogin: String?
    // let blocked: Bool?
    // let bannedUntil: String?
    // let bannedReason: String?
    let details: [Detail]
    // let sitting: Sitting?
    // let trading: Trading?
}

// MARK: - Detail
 struct Detail: Codable {
//    let type: String
//    let title: String
    let value: String
 }

// MARK: - ServerInfo
struct ServerInfo: Codable {
    let language: String
    let number: Int
}

// MARK: - Sitting
// struct Sitting: Codable {
//    let shared: Bool?
//    let endTime: String?
//    let cooldownTime: String?
// }

// MARK: - Trading
// struct Trading: Codable {
//    let trading: Bool?
//    let cooldownTime: String?
// }
