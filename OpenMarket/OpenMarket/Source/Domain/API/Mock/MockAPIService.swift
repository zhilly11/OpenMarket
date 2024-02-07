//  OpenMarket - MockAPIService.swift
//  Created by zhilly on 2024/02/04

import Alamofire
import Then

final class MockAPIService: OpenMarketAPIService {
    var session: Session

    init() {
        let configuration: URLSessionConfiguration = .default.then {
            $0.protocolClasses = [MockURLProtocol.self]
        }
        let session: Session = .init(configuration: configuration)

        self.session = session
    }

    func healthCheck() async -> Result<Bool, OpenMarketAPIError> {
        return .success(true)
    }

    func inquiryProductList(pageNumber: Int, itemsPerPage: Int, searchValue: String?) async -> Result<ProductList, OpenMarketAPIError> {
        return .success(MockData.productList)
    }

    func fetchProduct(id: Int) async -> Result<Product, OpenMarketAPIError> {
        return .success(MockData.product)
    }

    func createProduct(_ item: ParamsProduct, _ images: [Data]) async -> Result<Data, OpenMarketAPIError> {
        return .failure(.responseFail)
    }

    func inquiryDeleteURI(id: Int) async -> Result<String, OpenMarketAPIError> {
        return .failure(.responseFail)
    }

    func updateProduct(id: Int) {
        
    }

    func deleteProduct(path: String) async -> Result<Bool, OpenMarketAPIError> {
        return .failure(.responseFail)
    }
}
