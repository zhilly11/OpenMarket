//  OpenMarket - UIColor+.swift
//  Created by zhilly on 2024/01/08

import UIKit.UIColor

extension UIColor {
    static var customGray: UIColor {
        return UIColor(named: "CustomBackground") ?? UIColor.systemGray4
    }
    
    static var customBackground: UIColor {
        return color(light: .white, dark: .customGray)
    }
    
    private static func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
}
