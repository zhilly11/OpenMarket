//  OpenMarket - String+Extension.swift
//  Created by zhilly on 2023/03/23

import UIKit.UIColor

extension String {
    
    var doubleValue: Double {
        return Double(self) ?? .zero
    }
    
    func strikeThrough(length: Int, color: UIColor) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)

        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, length))
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor : color],
                                      range: NSMakeRange(0, length))

        return attributeString
    }
    
    func isContainsNonNumber() -> Bool {
        for character in self {
            if !character.isNumber { return true }
        }
        
        return false
    }
}
