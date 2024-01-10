//  OpenMarket - ProductListViewModel.swift
//  Created by zhilly on 2024/01/04

import RxCocoa
import RxSwift

final class ProductDetailViewModel: ViewModel {
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let product: BehaviorRelay<Product?>
        let failAlertAction: Signal<String>
        let fetchCompleted: PublishSubject<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let productID: Int
    private let product: BehaviorRelay<Product?> = .init(value: nil)
    private let failAlertAction = PublishRelay<String>()
    
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
                        let fetchedProduct = await owner.fetchProduct(id: owner.productID)
                        self.product.accept(fetchedProduct)
                        fetchCompleted.onNext(())
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            product: product,
            failAlertAction: failAlertAction.asSignal(),
            fetchCompleted: fetchCompleted
        )
    }
    
    @MainActor
    private func fetchProduct(id: Int) async -> Product? {
        do {
            let product = try await APIService.fetchProduct(id: id)
            return product
        } catch let error {
            self.failAlertAction.accept(error.localizedDescription)
            return nil
        }
    }
}
