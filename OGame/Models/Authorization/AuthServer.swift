//
//  AuthServer.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import UIKit
import Alamofire
import SwiftSoup

class AuthServer {
    private var serverID: Int = 0
    private var language: String = ""
    private var serverNumber: Int = 0
    private var universe: String = ""
    private var token: String = ""
    private var indexPHP: String = ""
    private var loginLink: String = ""
    private var landingPage: String = ""
    
    
    // MARK: - LOGIN INTO SERVER -
    func loginIntoServerWith(serverInfo: MyServer) async throws -> ServerData  {
        self.serverID = serverInfo.serverID
        self.language = serverInfo.language
        self.serverNumber = serverInfo.number
        self.universe = serverInfo.serverName
        self.token = serverInfo.token
        
        try await configureIndexPage()
        
        // MARK: - Configure Index
        func configureIndexPage() async throws {
            indexPHP = "https://s\(serverNumber)-\(language).ogame.gameforge.com/game/index.php?"
            let link = "https://lobby.ogame.gameforge.com/api/users/me/loginLink?"
            let parameters: Parameters = [
                "id": "\(self.serverID)",
                "server[language]": "\(self.language)",
                "server[number]": "\(self.serverNumber)",
                "clickedButton": "account_list"
            ]
            let headers: HTTPHeaders = ["authorization": "Bearer \(token)"]
            
            do {
                let response = try await AF.request(link, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).serializingDecodable(Index.self).value
                self.loginLink = response.url
                try await configureLandingPage()
                
            } catch {
                throw OGError(message: "Index page configuring error", detailed: error.localizedDescription)
            }
        }
        
        // MARK: - Configure Landing Page
        func configureLandingPage() async throws {
            do {
                let value = try await AF.request(loginLink).serializingData().value
                if let landingPage = String(data: value, encoding: .ascii) {
                    self.landingPage = landingPage
                    try await configureIngamePage()
                } else {
                    throw OGError()
                }
            } catch {
                throw OGError(message: "Landing page error (1)", detailed: error.localizedDescription)
            }
        }
        
        // MARK: - Configure Ingame Page
        func configureIngamePage() async throws {
            do {
                let link = "\(indexPHP)&page=ingame"
                let value = try await AF.request(link).serializingData().value
                if let landingPage = String(data: value, encoding: .ascii) {
                    self.landingPage = landingPage
                } else {
                    throw OGError()
                }
            } catch {
                throw OGError(message: "Landing page error (2)", detailed: error.localizedDescription)
            }
        }
        
        return ServerData(serverID: serverID,
                          language: language,
                          serverNumber: serverNumber,
                          universe: universe,
                          token: token,
                          indexPHP: indexPHP,
                          loginLink: loginLink,
                          landingPage: landingPage)
    }
}
