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
}
