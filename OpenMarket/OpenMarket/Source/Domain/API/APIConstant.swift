//  OpenMarket - APIConstant.swift
//  Created by zhilly on 2023/03/18

import Foundation

struct APIConstant {
    static var baseURL: URL {
        return URL(string: "http://openmarket.yagom-academy.kr")!
    }
    static let venderID = "zhilly"
    static let secret = "rzeyxdwzmjynnj3f"
    static let identifier = "f44cfc3e-6941-11ed-a917-47bc2e8f559b"
}

enum HTTPHeaderField: String {
    case identifier = "identifier"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
