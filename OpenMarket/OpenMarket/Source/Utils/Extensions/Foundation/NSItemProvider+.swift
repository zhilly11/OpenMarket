//  OpenMarket - NSItemProvider+.swift
//  Created by zhilly on 2024/01/17

import Foundation
import UIKit.UIImage

extension NSItemProvider {
    func convertToUIImage() -> UIImage? {
        var convertedImage: UIImage? = nil
        let semaphore: DispatchSemaphore = .init(value: 0)
        
        if self.canLoadObject(ofClass: UIImage.self) {
            self.loadObject(ofClass: UIImage.self) { loadImage, error in
                if let image = loadImage as? UIImage {
                    convertedImage = image
                }
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        return convertedImage
    }
    
    func convertToData() -> Data? {
        guard let image = self.convertToUIImage() else { return nil }
        return image.compressedData(withMaxSize: 1)
    }
    
    /* Using Swift Concurrency
    func loadObject(ofClass aClass: NSItemProviderReading.Type) async throws -> NSItemProviderReading {
        return try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: aClass) { (object, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let object = object {
                    continuation.resume(returning: object)
                } else {
                    fatalError("Unexpected case: Both object and error are nil.")
                }
            }
        }
    }

    func convertToUIImage() async -> UIImage? {
        guard canLoadObject(ofClass: UIImage.self) else {
            return nil
        }
        
        do {
            let loadedObject = try await self.loadObject(ofClass: UIImage.self)
            return loadedObject as? UIImage
        } catch {
            print("Error loading UIImage: \(error)")
            return nil
        }
    }
     */
}
