//
//  Auth.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class AuthAccount {
    static private var username: String = ""
    static private var password: String = ""
    static private let userAgent = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Mobile/15E148 Safari/604.1"]
    static private var attempt = 0
    static private var token = ""
    static private var serversListResponse: [Servers] = []
    static private var serversOnAccount: [MyServer] = []

    
    // MARK: - LOGIN INTO ACCOUNT
    static func loginIntoAccountWith(username: String, password: String) async throws -> [MyServer] {
        self.username = username
        self.password = password
        serversListResponse = []
        serversOnAccount = []
        
        try await login(attempt: attempt)
        
        // MARK: - Login
        func login(attempt: Int) async throws {
            let parameters = LoginData(identity: self.username,
                                       password: self.password,
                                       locale: "en_EN",
                                       gfLang: "en",
                                       platformGameId: "1dfd8e7e-6e1a-4eb1-8c64-03c3b62efd2f",
                                       gameEnvironmentId: "0a31d605-ffaf-43e7-aa02-d06df7116fc8",
                                       autoGameAccountCreation: false)

            let response = await AF.request("https://gameforge.com/api/v1/auth/thin/sessions", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200...409).serializingDecodable(Login.self).response
            
            guard response.response != nil
            else { throw OGError(message: "Network response error", detailed: "Try again later") }
            
            let statusCode = response.response!.statusCode

            switch response.result {
            case .success(_):
                self.token = response.value!.token
                self.attempt = 0
                try await configureServers()
                
            case .failure(let error):
                if statusCode == 409 && attempt < 10 {
                    let captchaToken = response.response?.headers["gf-challenge-id"]
                    let token = captchaToken!.replacingOccurrences(of: ";https://challenge.gameforge.com", with: "")
                    try await solveCaptcha(challenge: token)
                } else if attempt > 10 {
                    guard statusCode != 409 else {
                        throw OGError(message: "Captcha error", detailed: "Couldn't resolve captcha, try to solve it in browser and try again. (\(error.localizedDescription)")
                    }
                } else {
                    guard statusCode == 201 else {
                        throw OGError(message: "Login error", detailed: "Check your login data and try again. (\(error.localizedDescription)")
                        // Also called when can't captcha in
                    }
                }
            }
        }
        
        // MARK: - Solve Captcha
        func solveCaptcha(challenge: String) async throws {
            do {
                let getHeaders: HTTPHeaders = ["Cookie": "", "Connection": "close"]
                let _ = try await AF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", headers: getHeaders).serializingData().value
                
            } catch {
                throw OGError(message: "Captcha network request error", detailed: error.localizedDescription)
            }
            
            do {
                let postHeaders: HTTPHeaders = ["Content-type": "application/json"]
                let parameters = ["answer": 3]
                let _ = try await AF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: postHeaders).serializingData().value
                
            } catch {
                throw OGError(message: "Captcha network post error", detailed: error.localizedDescription)
            }
            
            do {
                attempt += 1
                try await login(attempt: attempt)
                
            } catch {
                throw OGError(message: "Captcha login retry error", detailed: error.localizedDescription)
            }
        }
        
        // MARK: - Configure Servers List
        func configureServers() async throws {
            do {
                let response = try await AF.request("https://lobby.ogame.gameforge.com/api/servers").serializingDecodable([Servers].self).value
                serversListResponse = response
                try await configureAccounts()
                
            } catch {
                throw OGError(message: "Server list network request error", detailed: error.localizedDescription)
            }
        }
        
        // MARK: - Configure Accounts
        func configureAccounts() async throws {
            do {
                let headers: HTTPHeaders = ["authorization": "Bearer \(token)"]
                let accounts = try await AF.request("https://lobby.ogame.gameforge.com/api/users/me/accounts", method: .get, headers: headers).serializingDecodable([Account].self).value
                
                for account in accounts {
                    for server in serversListResponse {
                        if account.server.number == server.number && account.server.language == server.language {
                            serversOnAccount.append(
                                MyServer(serverName: server.name,
                                         accountName: account.name,
                                         number: server.number,
                                         language: server.language,
                                         serverID: account.id,
                                         token: token))
                        }
                    }
                }
                
                guard !serversOnAccount.isEmpty else {
                    throw OGError(message: "No servers error", detailed: "Unable to get any active servers on account, make one and/or try again")
                }
                
            } catch {
                throw OGError(message: "Account configuration error", detailed: error.localizedDescription)
            }
        }
        
        return serversOnAccount
    }
}
