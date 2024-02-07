//  OpenMarket - MockURLProtocol.swift
//  Created by zhilly on 2024/02/04

import Foundation

final class MockURLProtocol: URLProtocol {
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    
    static var responseType: ResponseType!
    static var dtoType: MockDTOType!
    
    // Protocol이 parameter로 받은 request를 처리할 수 있는가?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // 표준 버전은 URLRequest를 반환하는 메서드 (표준버전?..)
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 캐시 처리 목적으로 두 요청이 동일한지 여부를 나타내는 메서드
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()
    
    private(set) var activeTask: URLSessionTask?
    
    override func startLoading() {
        let response: HTTPURLResponse? = setUpMockResponse()
        let data: Data? = setUpMockData()
        
        // 가짜 리스폰스 내보내기
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        
        // 가짜 데이터 내보내기
        client?.urlProtocol(self, didLoad: data!)
        
        // 로드 끝났어!!!!
        self.client?.urlProtocolDidFinishLoading(self)
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }
    
    private func setUpMockResponse() -> HTTPURLResponse? {
        var response: HTTPURLResponse?
        
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let newResponse)?:
            response = newResponse
        default:
            fatalError("No fake responses found.")
        }
        
        return response!
    }
    
    private func setUpMockData() -> Data? {
        let fileName: String = MockURLProtocol.dtoType.fileName
        
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return Data()
        }
        
        return try? Data(contentsOf: file)
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension MockURLProtocol {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
    
    static func responseWithDTO(type: MockDTOType) {
        MockURLProtocol.dtoType = type
    }
}

extension MockURLProtocol {
    
    enum MockDTOType {
        case invalidData
        case healthCheck
        case failHealthCheck
        case productList
        case product
        case createProduct
        case deleteURI
        
        var fileName: String {
            switch self {
            case .invalidData: return ""
            case .healthCheck: return "Response_healthCheck.json"
            case .failHealthCheck: return "Response_healthCheck_failure.json"
            case .productList: return "Response_productList.json"
            case .product, .createProduct: return "Response_product.json"
            case .deleteURI: return "Response_deleteURI.json"
            }
        }
    }
}
