//  OpenMarket - DateFormatter+.swift
//  Created by zhilly on 2024/01/09

import Foundation

extension DateFormatter {
    static func converted(date: Date, locale: Locale, dateStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = locale
        dateFormatter.dateStyle = dateStyle
        
        return dateFormatter.string(from: date)
    }
}

extension Date {
    var relativeTime_abbreviated: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.preference
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
