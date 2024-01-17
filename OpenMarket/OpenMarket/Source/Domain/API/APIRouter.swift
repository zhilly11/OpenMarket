//  OpenMarket - APIRouter.swift
//  Created by zhilly on 2023/03/18

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case healthChecker
    case inquiryProductList(pageNumber: Int, itemsPerPage: Int, searchValue: String? = nil)
    case inquiryProduct(id: Int)
    case createProduct
    case inquiryDeleteURI(id: Int)
    case updateProduct(id: Int)
    case deleteProduct(path: String)
    
    private var method: HTTPMethod {
        switch self {
        case .healthChecker, .inquiryProductList, .inquiryProduct:
            return .get
        case .createProduct, .inquiryDeleteURI:
            return .post
        case .updateProduct:
            return .patch
        case .deleteProduct:
            return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .inquiryProductList:
            return "api/products"
        case .inquiryProduct(let id):
            return "api/products/\(id)"
        case .createProduct:
            return "api/products"
        case .inquiryDeleteURI(let id):
            return "api/products/\(id)/archived"
        case .updateProduct(let id):
            return "api/products/\(id)"
        case .deleteProduct(let path):
            return "api/products/\(path)"
        }
    }
    
    private var query: [String: String] {
        switch self {
        case .inquiryProductList(let pageNumber, let itemsPerPage, let searchValue):
            
            var query: [String: String] = [
                "page_no": String(pageNumber),
                "items_per_page": String(itemsPerPage)
            ]
            
            if let search = searchValue {
                query.updateValue(search, forKey: "search_value")
            }
            
            return query
        default :
            return [:]
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .inquiryDeleteURI:
            return [
                "secret": APIConstant.secret
            ]
        default:
            return nil
        }
    }
    
    private var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = APIConstant.baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
        var queries: [URLQueryItem] = []
        
        for item in query {
            let queryItem: URLQueryItem = URLQueryItem(name: item.key, value: item.value)
            queries.append(queryItem)
        }
        
        components.queryItems = queries
        
        guard components.url != nil else {
            return URLRequest(url: URL(string: "")!)
        }
        var urlRequest = URLRequest(url: components.url!)
        
        urlRequest.method = method
        
        switch self {
        case .healthChecker:
            break
        case .inquiryProductList:
            break
        case .inquiryProduct:
            break
        case .createProduct:
            urlRequest.setValue(APIConstant.identifier,
                                forHTTPHeaderField: HTTPHeaderField.identifier.rawValue)
            break
        case .inquiryDeleteURI:
            urlRequest.setValue(APIConstant.identifier,
                                forHTTPHeaderField: HTTPHeaderField.identifier.rawValue)
            urlRequest.addValue(ContentType.json.rawValue,
                                forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        case .updateProduct:
            urlRequest.setValue(APIConstant.secret,
                                forHTTPHeaderField: HTTPHeaderField.identifier.rawValue)
            break
        case .deleteProduct:
            break
        }
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
                
        return urlRequest
    }
}
