//  OpenMarket - UITextField+.swift
//  Created by zhilly on 2024/01/10

import UIKit.UITextField

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
}
