//  OpenMarket - ProductListViewController.swift
//  Created by zhilly on 2024/01/02

import RxCocoa
import RxSwift

final class ProductListViewController: BaseTableViewController {
    
    typealias ViewModel = ProductListViewModel
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupView() {
        super.setupView()
        setupButtons()
    }
    
    override func setupBind() {
        super.setupBind()
        
        // MARK: - Input

        let viewDidLoadTrigger: Observable<()> = Observable.just(Void())
        let viewWillAppearTrigger: Observable<()> = rx.methodInvoked(#selector(viewWillAppear)).map { _ in () }
        let input: ViewModel.Input = .init(
            viewDidLoadTrigger: viewDidLoadTrigger,
            viewWillAppearTrigger: viewWillAppearTrigger,
            fetchMoreDatas: PublishSubject<Void>(),
            refreshAction: refreshController.rx.controlEvent(.valueChanged)
        )
        
        // MARK: - Output

        let output: ViewModel.Output = viewModel.transform(input: input)
        
        // MARK: - Binding

        output.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { _, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        output.viewWillAppearCompleted
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.tabBarController?.tabBar.isHidden = false
                    owner.title = Constant.Title.productList
                }
            )
            .disposed(by: disposeBag)
        
        output.failAlertAction
            .emit(
                with: self,
                onNext: { owner, _ in
                    let alert: UIAlertController = AlertFactory.make(.exit)
                    owner.present(alert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        output.refreshCompleted
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.refreshController.endRefreshing()
                }
            )
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .compactMap(\.last?.row)
            .bind(
                with: self,
                onNext: { viewController, row in
                    guard row == viewController.viewModel.productList.value.count - 1 else { return }
                    input.fetchMoreDatas.onNext(())
                }
            )
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Product.self)
            .subscribe(
                with: self,
                onNext: { owner, element in
                    let productID: Int = element.id
                    let productDetailViewController: UIViewController = ViewControllerFactory.make(
                        .productDetail(id: productID), dependency: .live
                    )
                    
                    owner.tabBarController?.tabBar.isHidden = true
                    owner.navigationController?.pushViewController(productDetailViewController,
                                                                   animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(
                with: self,
                onNext: { owner, indexPath in
                    owner.tableView.deselectRow(at: indexPath, animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setupButtons() {
        let presentAction: UIAction = .init(
            handler: { [weak self] _ in
                guard let self = self else { return }
                let registerViewController: UIViewController = ViewControllerFactory.make(.register, dependency: .live)
                
                registerViewController.modalPresentationStyle = .fullScreen
                self.present(registerViewController, animated: true)
            }
        )
        
        let addButton: UIBarButtonItem = .init(
            systemItem: .add,
            primaryAction: presentAction
        )
        
        navigationItem.rightBarButtonItem = addButton
    }
}

extension ProductListViewController: UITableViewDelegate { }

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ProductListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let viewController = ViewControllerFactory.make(.productList, dependency: .preview)
        viewController.showPreview(.iPhone14)
    }
}
#endif
