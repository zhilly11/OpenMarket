//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2023/03/23

import RxCocoa
import RxRelay
import RxSwift

final class ProductListViewModel: ViewModel, ProductListProvider {
    
    // MARK: - ViewModel
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let viewWillAppearTrigger: Observable<Void>
        let fetchMoreDatas: PublishSubject<Void>
        let refreshAction: ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppearCompleted: PublishSubject<Void>
        let productList: BehaviorRelay<[Product]>
        let failAlertAction: Signal<String>
        let refreshCompleted: PublishSubject<Void>
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let failAlertAction = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        let refreshCompleted: PublishSubject<Void> = .init()
        let viewWillAppearCompleted: PublishSubject<Void> = .init()
        
        input.viewDidLoadTrigger
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    Task {
                        if await owner.isServerOnline() {
                            await owner.fetchProductPage()
                        } else {
                            owner.failAlertAction.accept(OpenMarketAPIError.failHealthChecker.localizedDescription)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.viewWillAppearTrigger
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    viewWillAppearCompleted.onNext(())
                }
            )
            .disposed(by: disposeBag)
        
        input.fetchMoreDatas
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    Task {
                        await owner.fetchProductPage()
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
            viewWillAppearCompleted: viewWillAppearCompleted,
            productList: productList,
            failAlertAction: failAlertAction.asSignal(),
            refreshCompleted: refreshCompleted
        )
    }
    
    // MARK: - ProductListProvider
    
    var productList = BehaviorRelay<[Product]>(value: [])
    var pageCounter: Int = 1
    
    @MainActor
    func fetchProductPage() async {
        let productListResponse = await APIService.inquiryProductList(
            pageNumber: self.pageCounter,
            itemsPerPage: 20
        )
        
        switch productListResponse {
        case .success(let productList):
            let newData = productList.pages
            let oldData = self.productList.value
            
            self.productList.accept(oldData + newData)
            self.pageCounter += 1
            return
        case .failure(let error):
            self.failAlertAction.accept(error.localizedDescription)
        }
    }
}
