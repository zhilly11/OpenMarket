//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import Foundation
import RxSwift

final class ProductListViewModel {
    
    let productList = BehaviorSubject<[Product]>(value: [])
    
    init() {
        _ = APIService.inquiryProductList(pageNumber: 1, itemsPerPage: 100)
            .map { items -> [Product] in
                return items.pages
            }
            .take(1)
            .bind(to: productList)
    }
}

