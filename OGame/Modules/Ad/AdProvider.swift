//
//  AdProvider.swift
//  OGame
//
//  Created by Subvert on 4/16/22.
//

import Foundation
import SwiftSoup

final class AdProvider {
    
    static func getAds(doc: Document) -> [Ad] {
        do {
            let allAdsBox = try doc.select("[id=mmoNewsticker]")
            guard !allAdsBox.isEmpty() else { return [] }
            
            let allAds = try allAdsBox.get(0).select("[target=_blank]")
            var resultAds: [Ad] = []
            for ad in allAds {
                let adTitle = try ad.text()
                let adLinkString = try ad.attr("href")
                let adLink = URL(string: adLinkString)!
                resultAds.append(Ad(title: adTitle, link: adLink))
            }
            return resultAds
        } catch {
            return []
        }
    }
}
