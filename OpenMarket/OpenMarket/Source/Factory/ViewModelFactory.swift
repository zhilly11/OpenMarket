//  OpenMarket - ViewModelFactory.swift
//  Created by zhilly on 2024/02/07

enum ViewModelKind {
    case productList
    case productDetail(id: Int)
    case search
    case register
}

final class ViewModelFactory {
    static func make<T: ViewModel>(_ kind: ViewModelKind, type: FactoryDependency) -> T {
        var apiService: OpenMarketAPIService {
            switch type {
            case .live:
                return APIService()
            case .preview, .test:
                return MockAPIService()
            }
        }
        
        switch kind {
        case .productList:
            return ProductListViewModel(apiService: apiService) as! T
        case .productDetail(let id):
            return ProductDetailViewModel(apiService: apiService, productID: id) as! T
        case .search:
            return SearchViewModel(apiService: apiService) as! T
        case .register:
            return ProductRegisterViewModel(apiService: apiService) as! T
        }
    }
}
