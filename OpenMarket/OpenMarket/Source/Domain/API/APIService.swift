//  OpenMarket - APIService.swift
//  Created by zhilly on 2023/03/18

import Alamofire
import RxSwift

final class APIService {
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: OpenMarketAPIError) -> Void)
    
    static func request<T>(_ object: T.Type,
                           router: APIRouter,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T: Decodable {
        AF.request(router)
            .validate(statusCode: 200..<300)
            .response { data in
                switch data.result {
                case .success(let data):
                    guard let data = data else {
                        return failure(OpenMarketAPIError.invalidData)
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
                    failure(OpenMarketAPIError.unknown)
                }
            }
    }
    
    static func healthCheck(completion: @escaping (Result<String, OpenMarketAPIError>) -> Void) {
        request(String.self,
                router: .healthChecker) { result in
            completion(.success(result))
        } failure: { error in
            completion(.failure(.failHealthChecker))
        }
    }
    
    static func healthCheck() -> Observable<String> {
        return Observable.create { emitter in
            request(String.self,
                    router: .healthChecker) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            } failure: { _ in
                emitter.onError(OpenMarketAPIError.failHealthChecker)
            }
            
            return Disposables.create()
        }

    }
    
    static func inquiryProduct(id: Int) -> Observable<Product> {
        return Observable.create { emitter in
            request(Product.self,
                    router: .inquiryProduct(id: id)) { item in
                emitter.onNext(item)
                emitter.onCompleted()
            } failure: { error in
                emitter.onError(OpenMarketAPIError.inquiryProduct)
            }
            
            return Disposables.create()
        }
    }
    
    static func inquiryProductList(pageNumber: Int,
                                   itemsPerPage: Int,
                                   searchValue: String? = nil) -> Observable<ProductList> {
        return Observable.create() { emitter in
            request(ProductList.self,
                    router: .inquiryProductList(pageNumber: pageNumber,
                                                itemsPerPage: itemsPerPage,
                                                searchValue: searchValue)) { items in
                emitter.onNext(items)
                emitter.onCompleted()
            } failure: { _ in
                emitter.onError(OpenMarketAPIError.unknown)
            }
            
            return Disposables.create()
        }
    }
    
    static func createProduct() {}
    
    static func inquiryDeleteURI(id: Int) {
        request(String.self,
                router: .inquiryDeleteURI(id: id)) { item in
            print("delete ULI = \(item)")
            debugPrint(item)
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    static func updateProduct(id: Int) {
        
    }
    
    static func deleteProduct(path: String) {
        
    }
}
