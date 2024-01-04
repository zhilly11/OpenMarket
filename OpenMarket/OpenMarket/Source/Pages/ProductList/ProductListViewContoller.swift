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
        title = "오픈 마켓"
    }
    
    override func setupBind() {
        super.setupBind()
        
        let viewDidLoadTrigger = Observable.just(Void())
        let input = ProductListViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
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
                    let productDetailViewController = ProductDetailViewController(product: element)
                    productDetailViewController.modalPresentationStyle = .popover
                    owner.present(productDetailViewController, animated: true, completion: nil)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension ProductListViewController: UITableViewDelegate { }
