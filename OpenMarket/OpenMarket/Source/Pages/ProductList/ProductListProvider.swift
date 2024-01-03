//  OpenMarket - ProductListProvider.swift
//  Created by zhilly on 2024/01/03

import RxRelay

protocol ProductListProvider {
    var productList: BehaviorRelay<[Product]> { get set }
    var pageCounter: Int { get set }
    
    func checkServer() throws
    func fetchProductPage(pageNumber: Int) throws
}

extension ProductListProvider {
    func checkServer() throws {
        Task { try await APIService.healthCheck() }
    }
}
