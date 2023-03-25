//  OpenMarket - SearchViewModel.swift
//  Created by zhilly on 2023/03/25

import Foundation
import RxSwift

final class SearchViewModel {
    
    let productList = BehaviorSubject<[Product]>(value: [])
    private let disposeBag = DisposeBag()
    
    func search(_ searchValue: String) {
        if searchValue == "" {
            return
        } else {
            _ = APIService.inquiryProductList(pageNumber: 1, itemsPerPage: 30, searchValue: searchValue)
                .map { items -> [Product] in
                    return items.pages
                }
                .take(1)
                .subscribe(
                    onNext: { self.productList.onNext($0) },
                    onError: {
                        self.productList.onNext([])
                        print($0.localizedDescription)
                    }
                )
        }
    }
}
