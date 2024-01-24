//  OpenMarket - APIConstant.swift
//  Created by zhilly on 2023/03/18

import Foundation

/// API에 사용되는 변수들.
struct APIConstant {
    /// OpenMarket host URL
    static let baseURL: URL = .init(string: "http://openmarket.yagom-academy.kr")!
    
    // MARK: - Vender Info

    static let venderID: String = "zhilly"
    static let secret: String = "rzeyxdwzmjynnj3f"
    static let identifier: String = "f44cfc3e-6941-11ed-a917-47bc2e8f559b"
    
    // MARK: - API variable

    static let startPage: Int = 1
    static let itemPerPage: Int = 20
}

enum HTTPHeaderField: String {
    case identifier = "identifier"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
