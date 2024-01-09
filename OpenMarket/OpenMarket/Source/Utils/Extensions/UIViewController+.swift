//  OpenMarket - UIViewController+.swift
//  Created by zhilly on 2024/01/09

import UIKit.UIViewController

extension UIViewController {
    func setupNavigationBar(color: UIColor) {
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
