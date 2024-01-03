//  OpenMarket - ReusableView.swift
//  Created by zhilly on 2023/03/18

import UIKit.UIView

protocol ReusableView: UIView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
