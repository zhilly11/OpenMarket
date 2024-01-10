//  OpenMarket - Locale+Extension.swift
//  Created by zhilly on 2024/01/09

import Foundation

extension Locale {
    static var preference: Locale {
        guard let preferredLocaleIdentifier = Locale.preferredLanguages.first else { return current }
        return Locale(identifier: preferredLocaleIdentifier)
    }
}
