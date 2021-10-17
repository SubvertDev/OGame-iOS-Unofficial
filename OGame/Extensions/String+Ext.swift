//
//  String+Ext.swift
//  OGame
//
//  Created by Subvert on 02.10.2021.
//

import Foundation

extension String {
    
    private func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    private var upperCamelCased: String {
        return self.lowercased()
            .split(separator: " ")
            .map { return $0.lowercased().capitalizingFirstLetter() }
            .joined()
    }

    var lowerCamelCased: String {
        let upperCased = self.upperCamelCased
        return upperCased.prefix(1).lowercased() + upperCased.dropFirst()
    }

    func convertDateToString() -> String {
        let endDate = Date(timeIntervalSince1970: TimeInterval(self)!)
        let endFormatter = DateFormatter()
        endFormatter.timeZone = TimeZone.current
        endFormatter.dateFormat = "HH:mm:ss"
        return endFormatter.string(from: endDate)
    }
}

extension DateComponents {
    // Note: Does not handle decimal values or overflow values
    // Format: PnYnMnDTnHnMnS or PnW
    static func durationFrom8601String(_ durationString: String) -> DateComponents? {
        guard durationString.starts(with: "P") else {
            logErrorMessage(durationString: durationString)
            return nil
        }

        let durationString = String(durationString.dropFirst())
        var dateComponents = DateComponents()

        if durationString.contains("W") {
            let weekValues = componentsForString(durationString, designatorSet: CharacterSet(charactersIn: "W"))

            if let weekValue = weekValues["W"], let weekValueDouble = Double(weekValue) {
                // 7 day week specified in ISO 8601 standard
                dateComponents.day = Int(weekValueDouble * 7.0)
            }
            return dateComponents
        }

        let tRange = (durationString as NSString).range(of: "T", options: .literal)
        let periodString: String
        let timeString: String
        if tRange.location == NSNotFound {
            periodString = durationString
            timeString = ""
        } else {
            periodString = (durationString as NSString).substring(to: tRange.location)
            timeString = (durationString as NSString).substring(from: tRange.location + 1)
        }

        // DnMnYn
        let periodValues = componentsForString(periodString, designatorSet: CharacterSet(charactersIn: "YMD"))
        dateComponents.day = Int(periodValues["D"] ?? "")
        dateComponents.month = Int(periodValues["M"] ?? "")
        dateComponents.year = Int(periodValues["Y"] ?? "")

        // SnMnHn
        let timeValues = componentsForString(timeString, designatorSet: CharacterSet(charactersIn: "HMS"))
        dateComponents.second = Int(timeValues["S"] ?? "")
        dateComponents.minute = Int(timeValues["M"] ?? "")
        dateComponents.hour = Int(timeValues["H"] ?? "")

        return dateComponents
    }

    private static func componentsForString(_ string: String, designatorSet: CharacterSet) -> [String: String] {
        if string.isEmpty {
            return [:]
        }

        let componentValues = string.components(separatedBy: designatorSet).filter { !$0.isEmpty }
        let designatorValues = string.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }

        guard componentValues.count == designatorValues.count else {
            print("String: \(string) has an invalid format")
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: zip(designatorValues, componentValues))
    }

    private static func logErrorMessage(durationString: String) {
        print("String: \(durationString) has an invalid format")
        print("The durationString must have a format of PnYnMnDTnHnMnS or PnW")
    }
}
