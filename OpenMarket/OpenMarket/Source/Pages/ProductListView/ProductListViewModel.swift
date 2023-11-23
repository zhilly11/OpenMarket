//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import Foundation

import RxRelay
import RxSwift

final class ProductListViewModel {
    
    let productList = BehaviorRelay<[Product]>(value: [])
    var currentPage = BehaviorSubject<Int>(value: 1)

    private let disposeBag = DisposeBag()
    
    init() { }
    
    func serverCheck() throws {
        Task {
            let isServerOnline = try await APIService.healthCheck()
            
            if isServerOnline {
                try loadNextPage()
                return
            } else {
                throw OpenMarketAPIError.failHealthChecker
            }
        }
    }
    
    func loadNextPage() throws {
        Task {
            do {
                let currentPage = try self.currentPage.value()
                let response: ProductList = try await APIService.inquiryProductList(
                    pageNumber: currentPage,
                    itemsPerPage: 20
                )
                
                self.currentPage.onNext(currentPage + 1)
                
                await MainActor.run {
                    var currentValue = productList.value
                    productList.accept(currentValue + response.pages)
                }
            } catch let error {
                print(error)
                throw error
            }
        }
    }
}
