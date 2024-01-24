//  OpenMarket - ProductListViewController.swift
//  Created by zhilly on 2024/01/02

import RxCocoa
import RxSwift

final class ProductListViewController: BaseTableViewController {
    
    private let viewModel: ProductListViewModel
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupView() {
        super.setupView()
        setupButtons()
    }
    
    override func setupBind() {
        super.setupBind()
        
        let viewDidLoadTrigger = Observable.just(Void())
        let viewWillAppearTrigger = rx.methodInvoked(#selector(viewWillAppear)).map { _ in () }
        let input = ProductListViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            viewWillAppearTrigger: viewWillAppearTrigger,
            fetchMoreDatas: PublishSubject<Void>(),
            refreshAction: refreshController.rx.controlEvent(.valueChanged)
        )
        let output = viewModel.transform(input: input)
        
        output.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        output.viewWillAppearCompleted
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.tabBarController?.tabBar.isHidden = false
                    owner.title = "오픈마켓"
                }
            )
            .disposed(by: disposeBag)
        
        output.failAlertAction
            .emit(
                with: self,
                onNext: { owner, title in
                    let alert = AlertFactory.make(.exit)
                    owner.present(alert, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        output.refreshCompleted
            .subscribe(
                with: self,
                onNext: { owner, data in
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
                    let productID = element.id
                    let productDetailViewController = ViewControllerFactory.make(
                        .productDetail(id: productID)
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
                let registerViewController: UIViewController = ViewControllerFactory.make(.register)
                
                registerViewController.modalPresentationStyle = .fullScreen
                self.present(registerViewController, animated: true)
            }
        )
        
        let addButton: UIBarButtonItem = .init(
            systemItem: .add,
            primaryAction: presentAction
        )
        
        self.navigationItem.rightBarButtonItem = addButton
    }
}

extension ProductListViewController: UITableViewDelegate { }
