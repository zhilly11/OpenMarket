//  OpenMarket - JSONDecoder+.swift
//  Created by zhilly on 2023/03/24

import UIKit.NSDataAsset

extension JSONDecoder {
    
    static func decodeAsset<T: Decodable>(name: String, to type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        
        jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let formatter = DateFormatter()
            
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw JSONDecodeError.invalidData
        })
        
        var decodedData: T?
        
        guard let dataAsset = NSDataAsset(name: name) else {
            return nil
        }
        
        do {
            decodedData = try jsonDecoder.decode(T.self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
    
    static func decodeData<T: Decodable>(data: Data, to type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        
        if type is String.Type {
            return String(data: data, encoding: .utf8) as? T
        }
        
        jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let formatter = DateFormatter()
            
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw JSONDecodeError.invalidData
        })
        
        var decodedData: T?
        
        do {
            decodedData = try jsonDecoder.decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
}
