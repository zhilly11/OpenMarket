//  OpenMarket - UIImageView+Extension.swift
//  Created by zhilly on 2023/03/24

import UIKit

import Alamofire

extension UIImageView {

    func loadImage(_ url: String, width: CGFloat, height: CGFloat) {
        // MARK: 이미지 Load 순서
        // 1. 캐쉬에 저장되어 있다면 캐쉬에서 로드
        // 2. 캐쉬에 없다면 url을 통해 다운로드
        // 3. 캐쉬에 저장할때에는 다운샘플링한 이미지로
        
        DispatchQueue.global(qos: .background).async {
            let cachedKey: NSString = .init(string: url)
            
            // MARK: 캐쉬에 저장되어 있다면 캐쉬에서 로드
            if let cachedImage: UIImage = ImageCacheManager.shared.imageCache.object(forKey: cachedKey) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.image = cachedImage
                }
                return
            }
            
            // MARK: 캐쉬에 없다면 url을 통해 다운로드
            // url이 잘못되었을 떄
            guard let url: URL = .init(string: url) else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.image = Constant.Image.loadingFail
                }
                return
            }
            
            // 이미지 다운로드
            AF.request(url).response { response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                                        
                    switch response.result {
                    case .success(let data):
                        guard let data: Data = data else { return }
                        
                        // 이미지 다운에 성공했으면 다운샘플링
                        let downsampleImage: UIImage = self.downsample(imageData: data, width: width, height: height)
                        
                        // 다운 샘플링한 이미지를 캐쉬에 저장후 이미지 전달
                        ImageCacheManager.shared.imageCache.setObject(downsampleImage, forKey: cachedKey)
                        self.image = downsampleImage
                    case .failure:
                        self.image = Constant.Image.loadingFail
                    }
                }
            }
        }
    }
    
    func downsample(imageData: Data, width: CGFloat, height: CGFloat, scale: CGFloat = 1) -> UIImage {
        let imageSourceOptions: CFDictionary = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!
        let maxDimensionInPixels: CGFloat = max(width, height) * scale
        let downsampleOptions: CFDictionary = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as [CFString : Any] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return Constant.Image.loadingFail
        }
        return UIImage(cgImage: downsampledImage)
    }
}
