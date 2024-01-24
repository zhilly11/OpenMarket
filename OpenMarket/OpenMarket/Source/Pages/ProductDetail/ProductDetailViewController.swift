//  OpenMarket - ProductDetailViewController.swift
//  Created by zhilly on 2024/01/04

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class ProductDetailViewController: BaseViewController {
    
    typealias ViewModel = ProductDetailViewModel
    
    private let viewModel: ViewModel
    
    // MARK: - UI

    private let productDetailView = ProductDetailView()
    private let menubarItem: UIBarButtonItem = .init(image: UIImage(systemName: "ellipsis"), menu: nil)
    
    // MARK: - Input Properties

    private let deleteAction: PublishSubject<Void> = .init()
    private let editAction: PublishSubject<Void> = .init()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupView() {
        super.setupView()
        setupNavigationBar(color: .clear)
        setupNavigationItem()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(productDetailView)
        
        productDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        // MARK: - Input

        let viewDidLoadTrigger: Observable<Void> = Observable.just(Void())
        let input: ViewModel.Input = .init(
            viewDidLoadTrigger: viewDidLoadTrigger,
            deleteAction: self.deleteAction,
            editAction: self.editAction
        )
        
        // MARK: - Output

        let output: ViewModel.Output = viewModel.transform(input: input)
        let product: Observable<Product> = output.product.compactMap { $0 }
        
        // MARK: - ImageViews
        
        product
            .observe(on: MainScheduler.instance)
            .map { $0.images }
            .compactMap { $0 }
            .subscribe(
                with: self,
                onNext: { owner, images in
                    owner.productDetailView.setupImages(items: images)
                }
            )
            .disposed(by: disposeBag)
        
        productDetailView.imageScrollView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .map { $0.x }
            .subscribe(
                with: self,
                onNext: { owner, contentOffsetX in
                    owner.productDetailView.setPageControlSelectedPage(currentX: contentOffsetX)
                }
            )
            .disposed(by: disposeBag)
        
        // MARK: - ProfileView
        
        product
            .map { $0.vendors?.name }
            .bind(to: productDetailView.profileView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map { "ID: \($0.vendorID)" }
            .bind(to: productDetailView.profileView.venderIDLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - Description
        
        product
            .map { $0.name }
            .bind(to: productDetailView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map { $0.createdAt.relativeTime_abbreviated }
            .bind(to: productDetailView.createdAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map { $0.description }
            .bind(to: productDetailView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - FooterView
        
        product
            .map { "\($0.bargainPrice.convertNumberFormat())원" }
            .bind(to: productDetailView.footerView.priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        product
            .map { "남은수량: \($0.stock)개" }
            .bind(to: productDetailView.footerView.stockLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: - Delete
        
        output.deleteCompleted
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    let action: UIAlertAction = .init(
                        title: Constant.Button.check,
                        style: .default,
                        handler: { [unowned owner] _ in
                            owner.dismiss(animated: true)
                        }
                    )
                    
                    let alert: UIAlertController = AlertFactory.make(
                        .success(title: Constant.Message.success,
                                 message: Constant.Message.deleteCompleted,
                                 action: action)
                    )
                    
                    owner.present(alert, animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.topItem?.title = .init()
        
        let deleteAction: UIAction = .init(
            title: Constant.Button.delete,
            image: Constant.Image.delete,
            attributes: .destructive,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.deleteAction.onNext(())
            }
        )
        let editAction: UIAction = .init(
            title: Constant.Button.edit,
            image: Constant.Image.edit,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.editAction.onNext(())
            }
        )
        let barButtonMenu: UIMenu = .init(children: [deleteAction, editAction])
        
        menubarItem.menu = barButtonMenu
        navigationItem.rightBarButtonItem = menubarItem
    }
}
