//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import RxCocoa
import RxRelay
import RxSwift

final class ProductListViewModel: ViewModel, ProductListProvider {
    
    // MARK: - ViewModel
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let fetchMoreDatas: PublishSubject<Void>
    }
    
    struct Output {
        let productList: BehaviorRelay<[Product]>
        let failAlertAction: Signal<String>
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let failAlertAction = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        input.viewDidLoadTrigger
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        try self.checkServer()
                        try self.fetchProductPage(pageNumber: self.pageCounter)
                    } catch let error {
                        self.failAlertAction.accept(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.fetchMoreDatas
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        try self.fetchProductPage(pageNumber: self.pageCounter)
                    } catch let error {
                        self.failAlertAction.accept(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            productList: productList,
            failAlertAction: failAlertAction.asSignal()
        )
    }
    
    // MARK: - ProductListProvider
    
    var productList = BehaviorRelay<[Product]>(value: [])
    var pageCounter: Int = 1
    
    func fetchProductPage(pageNumber: Int) throws {
        Task.detached { [self] in
            print("fetch page: \(self.pageCounter)")
            let response: ProductList = try await APIService.inquiryProductList(
                pageNumber: self.pageCounter,
                itemsPerPage: 20
            )
            let newData = response.pages
            let oldData = productList.value
            
            productList.accept(oldData + newData)
            pageCounter += 1
        }
    }
}
