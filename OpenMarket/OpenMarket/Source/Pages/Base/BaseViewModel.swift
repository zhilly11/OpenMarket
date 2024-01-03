//  OpenMarket - BaseViewModel.swift
//  Created by zhilly on 2024/01/02

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
