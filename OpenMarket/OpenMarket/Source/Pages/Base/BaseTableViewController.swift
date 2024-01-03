//  OpenMarket - BaseTableViewController.swift
//  Created by zhilly on 2023/12/30

import UIKit

import SnapKit
import Then

class BaseTableViewController: BaseViewController {
    
    // MARK: - UI Component
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.refreshControl = refreshController
    }
    
    let refreshController = UIRefreshControl()
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.width.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
