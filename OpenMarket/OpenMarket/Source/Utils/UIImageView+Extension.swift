//  OpenMarket - UIImageView+Extension.swift
//  Created by zhilly on 2023/03/24

import UIKit

extension UIImageView {
    
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if let targetURL = url,
               let data = try? Data(contentsOf: targetURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func setImageUrl(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = cachedImage
                }
                return
            }
            
            guard let url = URL(string: url) else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage(systemName: "exclamationmark.triangle.fill")
                    }
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}
