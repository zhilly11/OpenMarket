//  OpenMarket - ViewControllerFactory.swift
//  Created by zhilly on 2023/03/31

import UIKit

enum ViewControllerKind {
    case productList
    case search
}

final class ViewControllerFactory {
    
    static func make(_ kind: ViewControllerKind) -> UIViewController {
        switch kind {
        case .productList:
            let productListViewModel = ProductListViewModel()
            let productListViewController = UINavigationController(
                rootViewController: ProductListViewController(viewModel: productListViewModel)
            )
            
            return productListViewController
        case .search:
            let searchViewModel = SearchViewModel()
            let searchViewController = UINavigationController(
                rootViewController: SearchViewController(viewModel: searchViewModel)
            )
            
            return searchViewController
        }
    }
}
