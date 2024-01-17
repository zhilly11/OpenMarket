//  OpenMarket - UIImage+.swift
//  Created by zhilly on 2024/01/17

import UIKit.UIImage

extension UIImage {
    func compressedData(withMaxSize maxSize: Int) -> Data? {
        var compressionQuality: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compressionQuality)
        
        while let data = imageData, data.count > maxSize && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            imageData = self.jpegData(compressionQuality: compressionQuality)
        }
        
        return imageData
    }
}
