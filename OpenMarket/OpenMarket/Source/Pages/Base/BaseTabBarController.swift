//  OpenMarket - BaseTabBarController.swift
//  Created by zhilly on 2024/01/08

import UIKit

import Then

class BaseTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        let appearance: UITabBarAppearance = .init().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .customBackground
        }
        
        tabBar.do {
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance
            $0.tintColor = .main
        }
    }
}
