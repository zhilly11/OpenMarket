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
    
    static func fetchProduct(id: Int) async throws -> Product {
        return try await request(Product.self, router: .inquiryProduct(id: id))
    }
    
    static func createProduct(_ item: ParamsProduct,
                              _ images: [Data]) async -> Result<Data, OpenMarketAPIError> {
        
        let jsonEncoder: JSONEncoder = .init()
        guard let paramsData: Data = try? jsonEncoder.encode(item) else {
            return .failure(OpenMarketAPIError.invalidData)
        }
        
        let uploadRequest = AF.upload(multipartFormData: { formData in
            formData.append(paramsData, withName: "params")
            
            images.forEach { data in
                formData.append(data,
                                withName: "images",
                                fileName: "productImage.png",
                                mimeType: "multipart/form-data")
            }
        }, with: APIRouter.createProduct)
            .validate()
        
        return await withCheckedContinuation { continuation in
            uploadRequest.responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: .success(data))
                case .failure(_):
                    continuation.resume(returning: .failure(OpenMarketAPIError.responseFail))
                }
            })
        }
    }
    
    static func inquiryDeleteURI(id: Int) async throws -> String {
        return try await request(String.self, router: .inquiryDeleteURI(id: id))
    }
    
    static func updateProduct(id: Int) {
        
    }
    
    static func deleteProduct(path: String) {
        
    }
}
