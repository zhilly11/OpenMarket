//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import Foundation
import RxSwift

final class ProductListViewModel {
    
    let productList = BehaviorSubject<[Product]>(value: [])
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
                let response = try await APIService.inquiryProductList(pageNumber: currentPage,
                                                                       itemsPerPage: 20)
                
                self.currentPage.onNext(currentPage + 1)
                
                await MainActor.run {
                    do {
                        var currentValue = try self.productList.value()
                        currentValue.append(contentsOf: response.pages)
                        self.productList.onNext(currentValue)
                    } catch {
                        
                    }
                }

            } catch let error {
                print(error)
                throw error
            }
        }
    }
}
