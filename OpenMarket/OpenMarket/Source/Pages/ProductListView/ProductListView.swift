//  OpenMarket - ProductListView.swift
//  Created by zhilly on 2023/03/18

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ProductListViewController: UIViewController {
    
    private let viewModel: ProductListViewModel
    private let disposeBag = DisposeBag()
        
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        $0.contentInsetAdjustmentBehavior = .scrollableAxes
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.refreshControl = refreshController
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    private let refreshController = UIRefreshControl()
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "상품명 검색"
    }
    
    private lazy var viewSpinner = UIView(
        frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
    ).then {
        let spinner = UIActivityIndicatorView()
        spinner.center = $0.center
        $0.addSubview(spinner)
        spinner.startAnimating()
    }
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkServerStatus()
    }
    
    private func checkServerStatus() {
        do {
            try viewModel.serverCheck()
            configure()
        } catch {
            let alert = AlertFactory.make(.exit)
            self.present(alert, animated: true)
        }
    }
    
    private func configure() {
        setupView()
        setupLayout()
        setupBind()
        setupRefreshController()
        viewModel.fetchMoreDatas.onNext(())
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.width.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBind() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchBar.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Product.self)
            .subscribe { element in
                let productDetailViewController = ProductDetailViewController(product: element)
                productDetailViewController.modalPresentationStyle = .popover
                self.present(productDetailViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                
                if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                    self.viewModel.fetchMoreDatas.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoadingSpinnerAvailable
            .subscribe { [weak self] isAvailable in
                guard let isAvailable = isAvailable.element, let self = self else { return }
                self.tableView.tableFooterView = isAvailable ? self.viewSpinner : UIView(frame: .zero)
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshControlCompleted
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.refreshController.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupRefreshController() {
        let refreshAction = UIAction { [weak self] _ in
            self?.viewModel.refreshControlAction.onNext(())
        }
        
        refreshController.addAction(refreshAction, for: .valueChanged)
    }
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let datasource: [Product] = viewModel.productList.value
        let imageThumbnail: String = datasource[indexPath.item].thumbnail
        let identifierString = NSString(string: "\(indexPath.row)")
        
        return UIContextMenuConfiguration(
            identifier: identifierString,
            previewProvider: {
                let previewController = PreviewViewController(thumbnailURL: imageThumbnail)
                
                return previewController
            },
            actionProvider: { suggestedActions in
                let inspectAction = UIAction(title: "inspect") { _ in
                    print("inspect")
                }
                let duplicateAction = UIAction(title: "duplicate") { _ in
                    print("duplicate")
                }
                let deleteAction = UIAction(title: "delete") { _ in
                    print("delete")
                }
                
                return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
            }
        )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}

extension ProductListViewController: UISearchBarDelegate {
    
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
