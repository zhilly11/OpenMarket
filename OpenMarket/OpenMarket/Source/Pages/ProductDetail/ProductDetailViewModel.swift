//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2024/01/04

import RxCocoa
import RxSwift

final class ProductDetailViewModel: ViewModel {
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let deleteAction: PublishSubject<Void>
        let editAction: PublishSubject<Void>
    }
    
    struct Output {
        let product: BehaviorRelay<Product?>
        let failAlertAction: Signal<String>
        let fetchCompleted: PublishSubject<Void>
        let deleteCompleted: Signal<String>
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let productID: Int
    private let product: BehaviorRelay<Product?> = .init(value: nil)
    private let failAlertAction: PublishRelay<String> = .init()
    private let deleteCompleted: PublishRelay<String> = .init()
    
    init(productID: Int) {
        self.productID = productID
    }
    
    func transform(input: Input) -> Output {
        let fetchCompleted: PublishSubject<Void> = .init()
        
        input.viewDidLoadTrigger
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    Task {
                        let fetchedProduct: Product? = await owner.fetchProduct(id: owner.productID)
                        self.product.accept(fetchedProduct)
                        fetchCompleted.onNext(())
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.deleteAction
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    Task {
                        let response: Result<String, OpenMarketAPIError> = await APIService.inquiryDeleteURI(id: owner.productID)
                        
                        switch response {
                        case .success(let deleteURL):
                            let result: Result<Bool, OpenMarketAPIError> = await APIService.deleteProduct(path: deleteURL)
                            
                            switch result {
                            case .success:
                                owner.deleteCompleted.accept(Constant.Message.deleteCompleted)
                            case .failure(let error):
                                owner.failAlertAction.accept(error.localizedDescription)
                            }
                        case .failure(let error):
                            owner.failAlertAction.accept(error.localizedDescription)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
        
        input.editAction
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    print("edit Action")
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            product: product,
            failAlertAction: failAlertAction.asSignal(),
            fetchCompleted: fetchCompleted,
            deleteCompleted: deleteCompleted.asSignal()
        )
    }
    
    @MainActor
    private func fetchProduct(id: Int) async -> Product? {
        let productResult = await APIService.fetchProduct(id: id)
        
        switch productResult {
        case .success(let product):
            return product
        case .failure(let error):
            self.failAlertAction.accept(error.localizedDescription)
            return nil
        }
    }
}
