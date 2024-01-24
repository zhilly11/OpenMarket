//  OpenMarket - APIService.swift
//  Created by zhilly on 2023/03/18

import Alamofire
import RxSwift

final class APIService {
    
    static func request<T>(
        _ object: T.Type,
        router: APIRouter
    ) async -> Result<T, OpenMarketAPIError> where T: Decodable {
        let dataTask: DataTask<Data> = AF.request(router).serializingData(automaticallyCancelling: true)
        
        switch await dataTask.result {
        case .success(let data):
            guard let response: HTTPURLResponse = await dataTask.response.response,
                  (200..<300) ~= response.statusCode else {
                return .failure(.responseFail)
            }
            
            guard let decodedData: T = JSONDecoder.decodeData(data: data, to: object) else {
                return .failure(.invalidData)
            }
            
            return .success(decodedData)
        case .failure:
            return .failure(.responseFail)
        }
    }
    
    static func healthCheck() async -> Result<Bool, OpenMarketAPIError> {
        let result: Result<String, OpenMarketAPIError> = await request(String.self, router: .healthChecker)
        
        switch result {
        case .success(let result):
            return result.trimmingCharacters(in: ["\""]) == "OK" ? .success(true) : .failure(.failHealthChecker)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func inquiryProductList(
        pageNumber: Int,
        itemsPerPage: Int,
        searchValue: String? = nil
    ) async -> Result<ProductList, OpenMarketAPIError> {
        return await request(ProductList.self,
                             router: .inquiryProductList(pageNumber: pageNumber,
                                                         itemsPerPage: itemsPerPage,
                                                         searchValue: searchValue))
    }
    
    static func fetchProduct(id: Int) async -> Result<Product, OpenMarketAPIError> {
        return await request(Product.self, router: .inquiryProduct(id: id))
    }
    
    static func createProduct(
        _ item: ParamsProduct,
        _ images: [Data]
    ) async -> Result<Data, OpenMarketAPIError> {
        
        let jsonEncoder: JSONEncoder = .init()
        guard let paramsData: Data = try? jsonEncoder.encode(item) else {
            return .failure(OpenMarketAPIError.invalidData)
        }
        
        let uploadRequest: UploadRequest = AF.upload(
            multipartFormData: { formData in
                formData.append(paramsData, withName: "params")
                
                images.forEach { data in
                    formData.append(data,
                                    withName: "images",
                                    fileName: "productImage.png",
                                    mimeType: "multipart/form-data")
                }
            },
            with: APIRouter.createProduct
        ).validate()
        
        return await withCheckedContinuation { continuation in
            uploadRequest.responseData(
                completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: .success(data))
                    case .failure(_):
                        continuation.resume(returning: .failure(OpenMarketAPIError.responseFail))
                    }
                }
            )
        }
    }
    
    static func inquiryDeleteURI(id: Int) async -> Result<String, OpenMarketAPIError> {
        let result = await request(String.self, router: .inquiryDeleteURI(id: id))
        
        switch result {
        case .success(let data):
            return .success(data.trimmingCharacters(in: ["\""]))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func updateProduct(id: Int) { }
    
    static func deleteProduct(path: String) async -> Result<Bool, OpenMarketAPIError> {
        let response: DataRequest = AF.request(APIRouter.deleteProduct(path: path))
        
        return await withCheckedContinuation { continuation in
            response.responseData(
                completionHandler: { response in
                    switch response.result {
                    case .success:
                        continuation.resume(returning: .success(true))
                    case .failure:
                        continuation.resume(returning: .failure(OpenMarketAPIError.responseFail))
                    }
                }
            )
        }
    }
}
