//
//  AdProvider.swift
//  OGame
//
//  Created by Subvert on 4/16/22.
//

import Foundation
import Alamofire
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
    
    static func getBanner(doc: Document) async throws -> Banner? {
        do {
            let bannerBox = try doc.select("[id=banner_skyscraper]")
            guard !bannerBox.isEmpty() else { return nil }
            
            let adLink = try bannerBox.select("[href*=https]").get(0).attr("href")
            
            let imageLink = try bannerBox.select("[src*=.jpg]").get(0).attr("src")
            let value = try await AF.request(imageLink).serializingData().value
            let image = UIImage(data: value)!
            
            return Banner(imageLink: imageLink, adLink: adLink, image: image)
        } catch {
            return nil
        }
    }
}
