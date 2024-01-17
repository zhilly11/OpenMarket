//  OpenMarket - ProductRegisterViewController.swift
//  Created by zhilly on 2024/01/10

import UIKit
import PhotosUI

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ProductRegisterViewController: BaseViewController {
    
    typealias ViewModelType = ProductRegisterViewModel
    
    private let viewModel: ViewModelType
    
    // MARK: - UI Component

    private let navigationBar: UINavigationBar = .init().then {
        $0.isTranslucent = false
        $0.barTintColor = .customBackground
    }
    
    private let registerView: ProductRegisterView = .init()
    private let registerButton: UIButton = .init().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .title3)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.titleLabel?.font = boldFont
        $0.setTitle("작성 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        
        $0.layer.cornerRadius = 7
        $0.backgroundColor = .main
    }
    
    private let registerButtonBackground: UIView = .init().then {
        $0.backgroundColor = .customBackground
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Property

    private var configuration: PHPickerConfiguration = .init(photoLibrary: .shared()).with {
        $0.selection = .ordered
        $0.selectionLimit = 5
        $0.filter = .any(of: [.images])
        $0.preferredAssetRepresentationMode = .current
    }
    
    // MARK: - Input for ViewModel

    /// Key: pictureID, Value: PHPickerResult.NSItemProvider
    private var selectedPictures: BehaviorRelay<[String: NSItemProvider]> = .init(value: [:])
    private var selectedAssetIdentifiers: BehaviorRelay<[String]> = .init(value: [])
    
    // MARK: - Setup

    override func setupView() {
        super.setupView()
        setupNavigationBar()
        setupButtons()
        
        Task {
            let data = try! await APIService.inquiryDeleteURI(id: 2356)
            print(data)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let safeArea = view.safeAreaLayoutGuide
        
        [navigationBar, registerView, registerButtonBackground, registerButton].forEach(view.addSubview(_:))
        
        registerButton.bringSubviewToFront(registerButtonBackground)
        
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeArea)
        }
        
        registerButtonBackground.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.height.equalTo(75)
        }
        
        registerButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(registerButtonBackground).inset(15)
            $0.top.equalTo(registerButtonBackground).inset(10)
            $0.bottom.equalTo(registerButtonBackground).inset(5)
        }
        
        registerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(registerButtonBackground.snp.top)
        }
    }
    
    override func setupBind() {
        // MARK: - Input

        let titleInput = registerView.nameTextField.textField.rx.text
        let priceInput = registerView.priceTextField.textField.rx.text
        let stockInput = registerView.stockTextField.textField.rx.text
        let descriptionInput = registerView.descriptionView.textView.rx.text
        let registerAction = registerButton.rx.tap
        
        let input: ViewModelType.Input = .init(
            title: titleInput,
            price: priceInput,
            stock: stockInput,
            description: descriptionInput,
            selectedPictures: self.selectedPictures,
            selectedAssetIdentifiers: self.selectedAssetIdentifiers,
            registerAction: registerAction
        )
        
        // MARK: - Output

        let output: ViewModelType.Output = viewModel.transform(input: input)
        
        output.registerCompleted
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    let alert = AlertFactory.make(.success(title: "성공",
                                                           message: "상품 등록에 성공했습니다."))
                    owner.present(alert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        output.failAlertAction
            .emit(
                with: self,
                onNext: { owner, title in
                    let alert = AlertFactory.make(.failure(title: title, message: nil))
                    owner.present(alert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        output.selectedAssetIdentifiers
            .subscribe(
                with: self,
                onNext: { owner, items in
                    owner.configuration.preselectedAssetIdentifiers = items
                }
            )
            .disposed(by: disposeBag)
        
        output.selectedImages
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, items in
                    owner.registerView.pictureScrollView.removeImageViews()
                    
                    items.forEach { item in
                        if let converted = item.convertToUIImage() {
                            owner.registerView.pictureScrollView.addImageView(item: converted)
                        } else {
                            print("image convert fail")
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // MARK: - TextView PlaceHolder Setting

        let textView = registerView.descriptionView.textView
        
        textView.rx.didBeginEditing
            .subscribe(
                with: self,
                onNext: { _, _ in
                    if textView.text == Constant.Placeholder.description {
                        textView.text = nil
                        textView.textColor = .label
                    }
                }
            )
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(
                with: self,
                onNext: { _, _ in
                    if textView.text == nil || textView.text.isEmpty {
                        textView.text = Constant.Placeholder.description
                        textView.textColor = .placeholderText
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        let title: UINavigationItem = .init(title: "내 물건 팔기")
        let dismissAction: UIAction = .init() { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        let dismissButton: UIBarButtonItem = .init(
            image: UIImage(systemName: "xmark"),
            primaryAction: dismissAction
        )
                                                
        dismissButton.tintColor = .label
        title.leftBarButtonItem = dismissButton
        
        navigationBar.setItems([title], animated: true)
    }
    
    private func setupButtons() {
        registerView.pictureScrollView.pictureSelectButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.changePictures()
            }),
            for: .touchUpInside
        )
    }
    
    private func changePictures() {
        let picker: PHPickerViewController = .init(configuration: configuration)

        picker.delegate = self

        self.present(picker, animated: true)
    }
}

extension ProductRegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        var newSelections: [String: NSItemProvider] = [:]
        
        results.forEach { result in
            if let identifier = result.assetIdentifier {
                newSelections[identifier] = self.selectedPictures.value[identifier] ?? result.itemProvider
            }
        }
        
        self.selectedPictures.accept(newSelections)
        self.selectedAssetIdentifiers.accept(results.compactMap { $0.assetIdentifier })
    }
}

extension PHPickerConfiguration: Then {}
