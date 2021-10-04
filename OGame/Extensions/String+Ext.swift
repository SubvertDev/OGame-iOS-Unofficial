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
