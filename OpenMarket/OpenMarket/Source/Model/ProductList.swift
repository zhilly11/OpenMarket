//  OpenMarket - ProductList.swift
//  Created by zhilly on 2023/03/18

struct ProductList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let pages: [Product]
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case itemsPerPage
        case totalCount
        case offset
        case limit
        case lastPage
        case hasNext
        case hasPrevious = "hasPrev"
        case pages
    }
}
