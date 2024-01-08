//  OpenMarket - ViewControllerFactory.swift
//  Created by zhilly on 2023/03/31

import UIKit

enum ViewControllerKind {
    case productList
    case productDetail(id: Int)
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
            
        case .productDetail(let id):
            let productDetailViewModel = ProductDetailViewModel(productID: id)
            let productDetailViewController = ProductDetailViewController(viewModel: productDetailViewModel)
            
            return productDetailViewController
            
        case .search:
            let searchViewModel = SearchViewModel()
            let searchViewController = UINavigationController(
                rootViewController: SearchViewController(viewModel: searchViewModel)
            )
            
            return searchViewController
        }
    }
}
