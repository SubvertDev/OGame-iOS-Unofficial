//
//  Resources.swift
//  OGame
//
//  Created by Subvert on 20.05.2021.
//

import Foundation
import SwiftSoup

struct Resources {
    var resources: [Int]
    var metal: Int
    var crystal: Int
    var deuterium: Int
    var dayProduction: [Int]
    var storage: [Int]
    var darkMatter: Int
    var energy: Int

    init(from doc: Document) {
        do {
            let metalString = try doc.select("[id=resources_metal]").get(0).attr("data-raw")
            let crystalString = try doc.select("[id=resources_crystal]").get(0).attr("data-raw")
            let deuteriumString = try doc.select("[id=resources_deuterium]").get(0).attr("data-raw")

            var resources = [Int]()
            for resource in [metalString, crystalString, deuteriumString] {
                resources.append(resourceToInt(resource))
            }
            self.resources = resources

            self.metal = resources[0]
            self.crystal = resources[1]
            self.deuterium = resources[2]

            func resourceToInt(_ resource: String) -> Int {
                let resourceConvert = resource.replacingOccurrences(of: "Mn", with: "000")
                return Int(Double(resourceConvert)!)
            }

            var dayProduction = [Int]()
            let dayProductionString = try doc.select("tr[class=summary alt]")
            let metalProduction = try dayProductionString.select("td[class=undermark]").get(0).select("span").attr("title")
            let crystalProduction = try dayProductionString.select("td[class=undermark]").get(1).select("span").attr("title")
            let deuteriumProduction = try dayProductionString.select("td[class=undermark]").get(2).select("span").attr("title")

            for resource in [metalProduction, crystalProduction, deuteriumProduction] {
                dayProduction.append(Int(resource.replacingOccurrences(of: ".", with: ""))!)
            }
            self.dayProduction = dayProduction

            var storageVolume = [Int]()
            let storageVolumeString = try doc.select("tr[class]")
            let metalStorage = try storageVolumeString.select("td[class*=left2]").get(0).select("span").attr("title")
            let crystalStorage = try storageVolumeString.select("td[class*=left2]").get(1).select("span").attr("title")
            let deuteriumStorage = try storageVolumeString.select("td[class*=left2]").get(2).select("span").attr("title")

            for storage in [metalStorage, crystalStorage, deuteriumStorage] {
                storageVolume.append(Int(storage.replacingOccurrences(of: ".", with: ""))!)
            }
            self.storage = storageVolume

            self.darkMatter = Int(try doc.select("[id=resources_darkmatter]").get(0).attr("data-raw")) ?? 0
            self.energy = Int(try doc.select("[id=resources_energy]").get(0).attr("data-raw")) ?? 0
        } catch {
            self.metal = -1
            self.crystal = -1
            self.deuterium = -1
            self.resources = [-1, -1, -1]
            self.dayProduction = [-1, -1, -1]
            self.storage = [-1, -1, -1]
            self.darkMatter = -1
            self.energy = -1
        }
    }
}
