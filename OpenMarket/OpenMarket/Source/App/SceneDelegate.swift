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
        
        let productListViewController = ViewControllerFactory.make(.productList)
        let searchViewController = ViewControllerFactory.make(.search)
        let tabBarController = ViewControllerFactory.make(
            .tabBarController(
                child: [productListViewController, searchViewController]
            )
        )
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
