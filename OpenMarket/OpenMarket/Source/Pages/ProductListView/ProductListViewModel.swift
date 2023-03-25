//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import Foundation
import RxSwift

final class ProductListViewModel {
    
    let productList = BehaviorSubject<[Product]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        _ = APIService.inquiryProductList(pageNumber: 1, itemsPerPage: 20)
            .map { items -> [Product] in
                return items.pages
            }
            .take(1)
            .subscribe(onNext: { self.productList.onNext($0) })
    }
    
    func load(pageNumber: Int) {
        
        var currentValue: [Product] = []
        let newValue = APIService.inquiryProductList(pageNumber: pageNumber, itemsPerPage: 20)
            .map { items -> [Product] in
                return items.pages
            }
            .take(1)
        
        do {
            currentValue = try productList.value()
        } catch {
            print("productList.value Error")
        }
        
        newValue
            .subscribe(onNext: { values in
                let updatedValues = currentValue + values
                
                Observable.from(updatedValues)
                    .toArray()
                    .subscribe(onSuccess: { array in
                        self.productList.onNext(array)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
