//  OpenMarket - Product.swift
//  Created by zhilly on 2023/03/18

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorID: Int
    let vendorName: String?
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [Image]?
    let vendors: Vendor?
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case vendors
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
