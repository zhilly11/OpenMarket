//  OpenMarket - TabBarFactory.swift
//  Created by zhilly on 2024/01/10

import UIKit

import Then

enum TabBarItemKind {
    case productList
    case productSearch
}

final class TabBarItemFactory {
    
    static func make(_ kind: TabBarItemKind) -> UITabBarItem {
        switch kind {
        case .productList:
            return UITabBarItem().then {
                $0.title = "홈"
                $0.image = UIImage(systemName: "house")
                $0.selectedImage = UIImage(systemName: "house.fill")
            }
        case .productSearch:
            return UITabBarItem().then {
                $0.title = "검색"
                $0.image = UIImage(systemName: "magnifyingglass.circle")
                $0.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
            }
        }
    }
}
