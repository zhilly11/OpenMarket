//  OpenMarket - SearchViewController.swift
//  Created by zhilly on 2023/03/20

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "상품명을 입력하세요."
        searchBar.showsCancelButton = false
        
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
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

extension SearchViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel.search(self.searchBar.text ?? "")
        self.searchBar.showsCancelButton = true
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(self.searchBar.text ?? "")
        self.searchBar.showsCancelButton = true
        self.tableView.reloadData()
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
//        guard let text = searchController.searchBar.text?.lowercased() else { return }
//        self.filterredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
        
        self.tableView.reloadData()
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    // 서치바 키보드 내리기
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
