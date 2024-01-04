//  OpenMarket - SearchViewController.swift
//  Created by zhilly on 2023/03/20

import UIKit

import RxCocoa
import RxSwift

final class SearchViewController: BaseTableViewController {
    
    private let viewModel: SearchViewModel
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "상품명을 입력하세요."
        $0.showsCancelButton = false
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupView() {
        super.setupView()
        
        navigationItem.titleView = searchBar
    }
    
    override func setupBind() {
        super.setupBind()
        
        let input = SearchViewModel.Input(
            fetchMoreDatas: PublishSubject<Void>(),
            searchKeyword: searchBar.rx.text.orEmpty,
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
        
        searchBar.rx.setDelegate(self)
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
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(!searchText.isEmpty, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}
