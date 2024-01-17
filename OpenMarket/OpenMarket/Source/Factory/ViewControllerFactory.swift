//  OpenMarket - ViewControllerFactory.swift
//  Created by zhilly on 2023/03/31

import UIKit

enum ViewControllerKind {
    case tabBarController(child: [UIViewController])
    case productList
    case productDetail(id: Int)
    case search
    case register
}

final class ViewControllerFactory {
    
    static func make(_ kind: ViewControllerKind) -> UIViewController {
        switch kind {
        case .tabBarController(let child):
            let tabBarController = BaseTabBarController()
            
            tabBarController.setViewControllers(child, animated: true)
            
            return tabBarController
        case .productList:
            let productListViewModel = ProductListViewModel()
            let productListViewController = UINavigationController(
                rootViewController: ProductListViewController(viewModel: productListViewModel)
            )
            productListViewController.tabBarItem = TabBarItemFactory.make(.productList)

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
            searchViewController.tabBarItem = TabBarItemFactory.make(.productSearch)

            return searchViewController
            
        case .register:
            let registerViewModel: ProductRegisterViewModel = .init()
            let registerViewController: ProductRegisterViewController = .init(viewModel: registerViewModel)
            
            return registerViewController
        }
    }
}
