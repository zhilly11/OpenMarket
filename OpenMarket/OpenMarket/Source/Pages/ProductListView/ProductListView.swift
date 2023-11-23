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
    
    private let refreshController: UIRefreshControl = .init()
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        $0.contentInsetAdjustmentBehavior = .scrollableAxes
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
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
        initRefresh()
        setupBind()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "오픈 마켓"
        tableView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.width.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupBind() {
        viewModel.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Product.self)
            .subscribe { element in
                let productDetailViewController = ProductDetailViewController(product: element)
                productDetailViewController.modalPresentationStyle = .popover
                self.present(productDetailViewController, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func loadNextPage() {
        do {
            try viewModel.loadNextPage()
            self.tableView.reloadData()
        } catch let error {
            let alert = AlertFactory.make(.failure(title: nil, message: error.localizedDescription))
            self.present(alert, animated: true)
        }
    }
}

extension ProductListViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //TODO: Paging Feature
    }

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
}

extension ProductListViewController {
    
    func initRefresh() {
        refreshController.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refreshController.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refreshController
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y < -0.1) {
            self.refreshTable(refresh: self.refreshController)
        }
    }
}
