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
        let refreshAction: ControlEvent<Void>
    }
    
    struct Output {
        let productList: BehaviorRelay<[Product]>
        let failAlertAction: Signal<String>
        let refreshCompleted: PublishSubject<Void>
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let failAlertAction = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        let refreshCompleted: PublishSubject<Void> = .init()
        
        input.viewDidLoadTrigger
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    do {
                        try owner.checkServer()
                        Task {
                            await owner.fetchProductPage(pageNumber: owner.pageCounter)
                        }
                    } catch let error {
                        owner.failAlertAction.accept(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.fetchMoreDatas
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    Task {
                        await owner.fetchProductPage(pageNumber: owner.pageCounter)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.refreshAction
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    print("refresh!")
                    owner.pageCounter = 1
                    owner.productList.accept([])
                    input.fetchMoreDatas.onNext(())
                    refreshCompleted.onNext(())
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            productList: productList,
            failAlertAction: failAlertAction.asSignal(),
            refreshCompleted: refreshCompleted
        )
    }
    
    // MARK: - ProductListProvider
    
    var productList = BehaviorRelay<[Product]>(value: [])
    var pageCounter: Int = 1
    
    @MainActor
    func fetchProductPage(pageNumber: Int) async {        
        do {
            let response: ProductList = try await APIService.inquiryProductList(
                pageNumber: self.pageCounter,
                itemsPerPage: 20
            )
            let newData = response.pages
            let oldData = self.productList.value
            
            self.productList.accept(oldData + newData)
            self.pageCounter += 1
        } catch let error {
            self.failAlertAction.accept(error.localizedDescription)
        }
    }
}
