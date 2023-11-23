//  OpenMarket - APIService.swift
//  Created by zhilly on 2023/03/18

import Alamofire
import RxSwift

final class APIService {
    
    static func request<T>(_ object: T.Type, router: APIRouter) async throws -> T where T: Decodable {
        let dataTask = AF.request(router).serializingData(automaticallyCancelling: true)
        
        switch await dataTask.result {
        case .success(let data):
            guard let response = await dataTask.response.response,
                  (200..<300).contains(response.statusCode) else {
                throw OpenMarketAPIError.responseFail
            }
            
            guard let decodedDate = JSONDecoder.decodeData(data: data, to: object) else {
                throw OpenMarketAPIError.invalidData
            }
            
            return decodedDate
        case .failure:
            throw OpenMarketAPIError.invalidData
        }
    }
    
    static func healthCheck() async throws -> Bool {
        let response = try await request(String.self, router: .healthChecker)
        
        return response.trimmingCharacters(in: ["\""]) == "OK" ? true : false
    }
    
    static func inquiryProductList(pageNumber: Int,
                                   itemsPerPage: Int,
                                   searchValue: String? = nil) async throws -> ProductList {
        return try await request(
            ProductList.self,
            router: .inquiryProductList(pageNumber: pageNumber,
                                        itemsPerPage: 20,
                                        searchValue: searchValue)
        )
    }
    
    static func createProduct() {
        
    }
    
    static func inquiryDeleteURI(id: Int) {

    }
    
    static func updateProduct(id: Int) {
        
    }
    
    static func deleteProduct(path: String) {
        
    }
}
