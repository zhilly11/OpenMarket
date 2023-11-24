//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import Foundation

import RxRelay
import RxSwift

final class ProductListViewModel {
    
    private let disposeBag = DisposeBag()
    
    let productList = BehaviorRelay<[Product]>(value: [])
    
    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompleted = PublishSubject<Void>()
    let isLoadingSpinnerAvailable = PublishSubject<Bool>()
    
    private var pageCounter = 1
    private var isPaginationRequestStillResume = false
    private var isRefreshRequestStillResume = false
    
    init() {
        setupBinding()
    }
    
    func serverCheck() throws {
        Task {
            try await APIService.healthCheck()
        }
    }
    
    private func setupBinding() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchProductPage(pageNumber: self.pageCounter, isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    private func fetchProductPage(pageNumber: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequestStillResume { return }
        
        self.isRefreshRequestStillResume = isRefreshControl
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvailable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvailable.onNext(false)
        }
        
        Task {
            do {
                let currentPage = self.pageCounter
                let response: ProductList = try await APIService.inquiryProductList(
                    pageNumber: currentPage,
                    itemsPerPage: 20
                )
                
                await MainActor.run {
                    handleResponse(data: response.pages)
                    isLoadingSpinnerAvailable.onNext(false)
                    isPaginationRequestStillResume = false
                    isRefreshRequestStillResume = false
                    refreshControlCompleted.onNext(())
                }
            } catch {
                //TODO: Error Handling
            }
        }
    }
    
    private func handleResponse(data: [Product]) {
        let oldData = productList.value
        productList.accept(oldData + data)
        pageCounter += 1
    }
    
    private func refreshControlTriggered() {
        isPaginationRequestStillResume = false
        pageCounter = 1
        productList.accept([])
        fetchProductPage(pageNumber: pageCounter, isRefreshControl: true)
    }
}
