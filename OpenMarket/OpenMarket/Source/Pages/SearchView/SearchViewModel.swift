//  OpenMarket - SearchViewModel.swift
//  Created by zhilly on 2023/03/25

import Foundation
import RxSwift

final class SearchViewModel {
    
    let productList = BehaviorSubject<[Product]>(value: [])
    private let disposeBag = DisposeBag()
    
    func search(_ searchValue: String) {
        
    }
}
