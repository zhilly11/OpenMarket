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
                $0.title = Constant.TabBar.Title.home
                $0.image = Constant.TabBar.Image.home
                $0.selectedImage = Constant.TabBar.SelectedImage.home
            }
        case .productSearch:
            return UITabBarItem().then {
                $0.title = Constant.TabBar.Title.search
                $0.image = Constant.TabBar.Image.search
                $0.selectedImage = Constant.TabBar.SelectedImage.search
            }
        }
    }
}
