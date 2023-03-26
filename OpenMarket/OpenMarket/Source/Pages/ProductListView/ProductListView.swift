//  OpenMarket - ProductListView.swift
//  Created by zhilly on 2023/03/18

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ProductListViewController: UIViewController {
    
    private let viewModel: ProductListViewModel
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private let refreshController: UIRefreshControl = .init()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        
        return tableView
    }()
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
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
        
        tableView.delegate = self
        
        setupView()
        initRefresh()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "오픈 마켓"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        viewModel.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
    }
}

extension ProductListViewController: UITableViewDelegate {

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset < currentOffset {
            viewModel.load(pageNumber: currentPage)
            currentPage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
            }
        }
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
