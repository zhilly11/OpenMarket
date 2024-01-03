//  OpenMarket - ImageCacheManager.swift
//  Created by zhilly on 2023/12/01

import UIKit.UIImage

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}