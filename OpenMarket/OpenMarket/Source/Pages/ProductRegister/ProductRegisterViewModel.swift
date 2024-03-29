//  OpenMarket - ProductRegisterViewModel.swift
//  Created by zhilly on 2024/01/11

import RxCocoa
import RxRelay
import RxSwift

final class ProductRegisterViewModel: ViewModel {
    
    struct Input {
        let title: ControlProperty<String?> // 상품 이름
        let price: ControlProperty<String?> // 상품 가격
        let stock: ControlProperty<String?> // 상품 재고
        let description: ControlProperty<String?>   // 상품 설명
        let selectedPictures: BehaviorRelay<[String: NSItemProvider]>   // 사용자가 선택한 사진의 [id: Data]
        let selectedAssetIdentifiers: BehaviorRelay<[String]> // 사용자가 선택한 사진의 식별자 목록
        
        let registerAction: ControlEvent<Void> // 등록 요청
    }
    
    struct Output {
        let selectedImages: BehaviorRelay<[NSItemProvider]> // 사진 데이터들
        let selectedAssetIdentifiers: BehaviorRelay<[String]> // 사용자가 선택하고 있는 사진의 식별자 목록
        let failAlertAction: Signal<String> // 경고 alert을 띄우기 위한 프로퍼티
        let registerCompleted: PublishSubject<Void> // 상품 등록 완료 알림
        let registerResume: PublishSubject<Bool>
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let selectedAssetIdentifiers: BehaviorRelay<[String]> = .init(value: [])
    private let failAlertAction: PublishRelay<String> = .init()
    
    private var title: String = .init()
    private var price: String = .init()
    private var stock: String = .init()
    private var description: String = .init()
    
    func transform(input: Input) -> Output {
        let selectedImages: BehaviorRelay<[NSItemProvider]> = .init(value: [])
        let registerCompleted: PublishSubject<Void> = .init()
        let registerResume: PublishSubject<Bool> = .init()
        
        input.title.orEmpty
            .subscribe(
                with: self,
                onNext: { owner, text in
                    owner.title = text
                }
            )
            .disposed(by: disposeBag)
        
        input.price.orEmpty
            .subscribe(
                with: self,
                onNext: { owner, text in
                    owner.price = text
                }
            )
            .disposed(by: disposeBag)
        
        input.stock.orEmpty
            .subscribe(
                with: self,
                onNext: { owner, text in
                    owner.stock = text
                }
            )
            .disposed(by: disposeBag)
        
        input.description.orEmpty
            .subscribe(
                with: self,
                onNext: { owner, text in
                    owner.description = text
                }
            )
            .disposed(by: disposeBag)
        
        input.selectedAssetIdentifiers
            .subscribe(
                with: self,
                onNext: { owner, items in
                    owner.selectedAssetIdentifiers.accept(items)
                }
            )
            .disposed(by: disposeBag)
        
        input.selectedPictures
            .subscribe(
                with: self,
                onNext: { owner, items in
                    selectedImages.accept(items.compactMap { $0.value })
                }
            )
            .disposed(by: disposeBag)
                
        input.registerAction
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    registerResume.onNext(true)
                    
                    let result: Result<ParamsProduct, RegisterError> = owner.makeParamsProduct()
                    
                    switch result {
                    case .success(let paramsProduct):
                        let imagesDatas: [Data] = selectedImages.value.map { $0.convertToData()! }
                        
                        Task {
                            let result: Result<Data, OpenMarketAPIError> = await APIService.createProduct(paramsProduct, imagesDatas)
                            
                            switch result {
                            case .success(_):
                                registerResume.onNext(false)
                                registerCompleted.onNext(())
                            case .failure(let error):
                                registerResume.onNext(false)
                                owner.failAlertAction.accept(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        registerResume.onNext(false)
                        owner.failAlertAction.accept(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            selectedImages: selectedImages,
            selectedAssetIdentifiers: self.selectedAssetIdentifiers,
            failAlertAction: self.failAlertAction.asSignal(),
            registerCompleted: registerCompleted,
            registerResume: registerResume
        )
    }
}

extension ProductRegisterViewModel {
    private func makeParamsProduct() -> Result<ParamsProduct, RegisterError> {
        do {
            try isCorrect()
            
            let result: ParamsProduct = .init(
                name: self.title,
                description: self.description,
                price: self.price.doubleValue,
                currency: .KRWString,
                secret: APIConstant.secret
            )
            
            return .success(result)
        } catch let error as RegisterError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func isCorrect() throws {
        if !(1...5).contains(selectedAssetIdentifiers.value.count) { throw RegisterError.wrongImageCount }
        if title.isEmpty { throw RegisterError.emptyTitle }
        if price.isEmpty || price.isContainsNonNumber() { throw RegisterError.wrongPrice }
        if stock.isEmpty || stock.isContainsNonNumber() { throw RegisterError.emptyStock }
        if description.isEmpty || description == Constant.Placeholder.description{ throw RegisterError.emptyDescription }
    }
}
