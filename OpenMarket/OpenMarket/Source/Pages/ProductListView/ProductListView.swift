//  OpenMarket - ProductListView.swift
//  Created by zhilly on 2023/03/18

import UIKit
import RxSwift
import RxCocoa

final class ProductListViewController: UIViewController {
    
    private let viewModel = ProductListViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        viewModel.productList
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ProductCell.reuseIdentifier,
                                         cellType: ProductCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
