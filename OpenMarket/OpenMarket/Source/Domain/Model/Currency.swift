//  OpenMarket - Currency.swift
//  Created by zhilly on 2023/03/18

import UIKit

enum Currency: String, Codable {
    case KRWString = "KRW"
    case USDString = "USD"
    case JPYString = "JPY"
    case HKDString = "HKD"
    
    var symbol: String {
        let locale = NSLocale(localeIdentifier: self.rawValue)
        if let symbol = locale.displayName(forKey: .currencySymbol, value: self.rawValue) {
            return symbol
        }
        
        return String()
    }
}
