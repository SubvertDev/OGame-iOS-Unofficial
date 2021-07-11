//
//  Resources.swift
//  OGame
//
//  Created by Subvert on 20.05.2021.
//

import Foundation
import SwiftSoup

struct Resources {

    let resources: [Int]
    let metal: Int
    let crystal: Int
    let deuterium: Int
    let dayProduction: [Int]
    let storage: [Int]
    let darkMatter: Int
    let energy: Int
    

    // TODO: Very optimizable
    init(from doc: Document) {

        let metal = try! doc.select("[id=resources_metal]").get(0).attr("data-raw")
        let crystal = try! doc.select("[id=resources_crystal]").get(0).attr("data-raw")
        let deuterium = try! doc.select("[id=resources_deuterium]").get(0).attr("data-raw")

        func resourceToInt(_ resource: String) -> Int {
            let resourceConvert = resource.replacingOccurrences(of: "Mn", with: "000")
            return Int(Double(resourceConvert)!)

        }

        var resources = [Int]()
        for resource in [metal, crystal, deuterium] {
            resources.append(resourceToInt(resource))
        }
        self.resources = resources

        self.metal = resources[0]
        self.crystal = resources[1]
        self.deuterium = resources[2]
        
        var dp = [Int]()
        //let dayProduction = try! doc.select("tr[class=summary]")
        let dayProduction = try! doc.select("tr[class=summary alt]")

        let metalProduction = try! dayProduction.select("td[class=undermark]").get(0).select("span").attr("title")
        let crystalProduction = try! dayProduction.select("td[class=undermark]").get(1).select("span").attr("title")
        let deuteriumProduction = try! dayProduction.select("td[class=undermark]").get(2).select("span").attr("title")

        for resource in [metalProduction, crystalProduction, deuteriumProduction] {
            dp.append(Int(resource.replacingOccurrences(of: ".", with: ""))!)
        }
        self.dayProduction = dp
            
        var str = [Int]()
        //let storageInfo = try! doc.select("tr[class=alt]").get(1)
        let storageInfo = try! doc.select("tr[class]") // .get(16)

        let metalStorage = try! storageInfo.select("td[class*=left2]").get(0).select("span").attr("title")
        let crystalStorage = try! storageInfo.select("td[class*=left2]").get(1).select("span").attr("title")
        let deuteriumStorage = try! storageInfo.select("td[class*=left2]").get(2).select("span").attr("title")
        
        for element in [metalStorage, crystalStorage, deuteriumStorage] {
            str.append(Int(element.replacingOccurrences(of: ".", with: ""))!)
        }
        self.storage = str
        
        self.darkMatter = Int(try! doc.select("[id=resources_darkmatter]").get(0).attr("data-raw"))!
        
        self.energy = Int(try! doc.select("[id=resources_energy]").get(0).attr("data-raw"))!
        
        print("Resources initialized:")
        print("Resources: \(resources)")
        print("Metal: \(metal)")
        print("Crystal: \(crystal)")
        print("Deuterium: \(deuterium)")
        print("Energy: \(energy)")
        print("Dark Matter: \(darkMatter)")
        print("Day Production: \(dp)")
        print("Storage Capacity: \(storage)")
    }

}
