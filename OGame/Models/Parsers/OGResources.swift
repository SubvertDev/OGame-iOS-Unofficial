//
//  OGResources.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGResources {
        
    // MARK: - Get Resources
    func getResourcesWith(playerData: PlayerData) async throws -> Resources {
        do {
            let link = "\(playerData.indexPHP)page=resourceSettings&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)
            
            guard !noScriptCheck(with: page)
            else { throw OGError(message: "Not logged in", detailed: "Resources view login check failed") }
            
            return Resources(from: page)
            
        } catch {
            throw OGError(message: "Resources network error", detailed: error.localizedDescription)
        }
    }
}
