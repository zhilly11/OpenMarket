//  OpenMarket - SceneDelegate.swift
//  Created by zhilly on 2023/03/18

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let tabBarController = UITabBarController()
        let productListViewController = UINavigationController(rootViewController: ProductListViewController())
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        
        tabBarController.setViewControllers([productListViewController,
                                             searchViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[safe: 0]?.selectedImage = UIImage(systemName: "house.fill")
            items[safe: 0]?.image = UIImage(systemName: "house")
            items[safe: 0]?.title = "목록"
            
            items[safe: 1]?.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
            items[safe: 1]?.image = UIImage(systemName: "magnifyingglass.circle")
            items[safe: 1]?.title = "검색"
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
