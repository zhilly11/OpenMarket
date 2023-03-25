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
}
