//  OpenMarket - ProductListProvider.swift
//  Created by zhilly on 2024/01/03

import RxRelay

protocol ProductListProvider {
    var productList: BehaviorRelay<[Product]> { get set }
    var pageCounter: Int { get set }
    
    func fetchProductPage() async
}

extension ProductListProvider {
    func isServerOnline() async -> Bool {
        switch await APIService.healthCheck() {
        case .success: return true
        case .failure: return false
        }
    }
}
