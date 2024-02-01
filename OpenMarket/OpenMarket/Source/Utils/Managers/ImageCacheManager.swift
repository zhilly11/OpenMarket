//  OpenMarket - ImageCacheManager.swift
//  Created by zhilly on 2023/12/01

import UIKit.UIImage

final class ImageCacheManager {
    static let shared: ImageCacheManager = .init()
    let imageCache: NSCache<NSString, UIImage> = .init()
    
    private init() {}
}
