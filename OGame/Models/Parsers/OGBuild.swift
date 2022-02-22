//
//  OGBuild.swift
//  OGame
//
//  Created by Subvert on 16.01.2022.
//

import Foundation
import Alamofire
import SwiftSoup

class OGBuild {
    
    // MARK: - Build
    static func build(what: (Int, Int, String), playerData: PlayerData) async throws {
        do {
            let build = (type: what.0, amount: what.1, component: what.2)
            
            let link = "\(playerData.indexPHP)page=ingame&component=\(build.component)&cp=\(playerData.planetID)"
            let value = try await AF.request(link).serializingData().value
            
            let text = String(data: value, encoding: .ascii)!
            let pattern = "var urlQueueAdd = (.*)token=(.*)';"
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            let matches = results.map { nsString.substring(with: $0.range)}
            
            guard !matches.isEmpty
            else { throw OGError(message: "Building error", detailed: "Regex matches are empty") }
            
            let match = matches[0]
            
            let strIndex = match.range(of: "token=")?.upperBound
            var final = match[strIndex!...]
            final.removeLast(2)
            let buildToken = final
            
            let parameters: Parameters = [
                "page": "ingame",
                "component": build.component,
                "modus": 1,
                "token": buildToken,
                "type": build.type,
                "menge": build.amount
            ]
            
            let _ = try await AF.request(playerData.indexPHP, parameters: parameters).serializingData().value
        } catch {
            throw OGError(message: "Building error", detailed: error.localizedDescription)
        }
    }
}
