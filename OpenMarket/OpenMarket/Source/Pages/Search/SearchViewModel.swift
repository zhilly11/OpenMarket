//  OpenMarket - SearchViewModel.swift
//  Created by zhilly on 2023/03/25

import RxCocoa
import RxRelay
import RxSwift

protocol ProductSearchable {
    var searchKeyword: String { get set }
}

final class SearchViewModel: ViewModel, ProductListProvider, ProductSearchable {
    
    private let failAlertAction = PublishRelay<String>()
    
    // MARK: - ViewModel
        
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let fetchMoreDatas: PublishSubject<Void>
        let searchKeyword: ControlProperty<String>
        let refreshAction: ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppearCompleted: PublishSubject<Void>
        let productList: BehaviorRelay<[Product]>
        let failAlertAction: Signal<String>
        let refreshCompleted: PublishSubject<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let refreshCompleted: PublishSubject<Void> = .init()
        let viewWillAppearCompleted: PublishSubject<Void> = .init()
        
        input.searchKeyword
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(
                with: self,
                onNext: { owner, string in
                    owner.pageCounter = 1
                    owner.searchKeyword = string
                    owner.productList.accept([])
                    
                    Task { await owner.fetchProductPage() }
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
        do {
            if searchKeyword.isEmpty || searchKeyword == "" {
                self.productList.accept([])
                return
            }
            
            let response: ProductList = try await APIService.inquiryProductList(
                pageNumber: self.pageCounter,
                itemsPerPage: 20,
                searchValue: self.searchKeyword
            )
            let newData = response.pages
            let oldData = self.productList.value
            
            self.productList.accept(oldData + newData)
            self.pageCounter += 1
        } catch OpenMarketAPIError.invalidData {
            print("더 이상 데이터가 없습니다.")
        } catch let error {
            self.failAlertAction.accept(error.localizedDescription)
        }
    }
    
    // MARK: - ProductSearchable
    
    var searchKeyword: String = .init()
}
