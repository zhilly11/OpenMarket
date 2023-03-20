//  OpenMarket - NetworkManager.swift
//  Created by zhilly on 2023/03/18

import Alamofire

final class NetworkManager {
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: Error) -> Void)
    
    private func request<T>(_ object: T.Type,
                            router: APIRouter,
                            success: @escaping onSuccess<T>,
                            failure: @escaping onFailure) where T: Decodable {
        AF.request(router)
            .validate(statusCode: 200..<300)
            .response { data in
                switch data.result {
                case .success(let data):
                    guard let data = data else {
                        return failure(JSONDecodeError.invalidData)
                    }
                    
                    if object == String.self,
                       let url = String(data: data, encoding: .utf8) {
                        success(url as! T)
                    }
                    
                    else if object == Product.self {
                        success(JSONDecoder.decodeData(data: data, to: object)!)
                    }
                    
                    else if object == ProductList.self {
                        success(JSONDecoder.decodeData(data: data, to: object)!)
                    }
                case .failure(_):
                    failure(OpenMarketAPIError.unknownError)
                }
            }
    }
}

extension NetworkManager: OpenMarketAPI {
    
    func healthCheck(completion: @escaping (Result<String, OpenMarketAPIError>) -> Void) {
        request(String.self,
                router: .healthChecker) { result in
            completion(.success(result))
        } failure: { error in
            completion(.failure(.failHealthChecker))
        }
    }
    
    func inquiryProduct(id: Int, completion: @escaping (Result<Product, OpenMarketAPIError>) -> Void) {
        request(Product.self,
                router: .inquiryProduct(id: id)) { item in
            completion(.success(item))
        } failure: { error in
            completion(.failure(.unknownError))
        }
    }
    
    func inquiryProductList(pageNumber: Int,
                            itemsPerPage: Int,
                            searchValue: String? = nil,
                            completion: @escaping (Result<ProductList, OpenMarketAPIError>) -> Void) {
        request(ProductList.self,
                router: .inquiryProductList(pageNumber: pageNumber,
                                            itemsPerPage: itemsPerPage,
                                            searchValue: searchValue)) { item in
            completion(.success(item))
        } failure: { error in
            completion(.failure(.unknownError))
        }
        
    }
    
    func createProduct() {}
    
    func inquiryDeleteURI(id: Int) {
        request(String.self,
                router: .inquiryDeleteURI(id: id)) { item in
            print("delete ULI = \(item)")
            debugPrint(item)
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    func updateProduct(id: Int) {
        
    }
    
    func deleteProduct(path: String) {
        
    }
}
