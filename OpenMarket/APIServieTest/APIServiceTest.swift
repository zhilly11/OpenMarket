//  APIServiceTest - APIServiceTest.swift
//  Created by zhilly on 2024/02/04

import XCTest

@testable import OpenMarket
import Alamofire

final class APIServiceTest: XCTestCase {
    
    var sut: APIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let session: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        
        sut = APIService(session: session)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    // MARK: - request test

    func test_request_invalidData_ProductType_decoding_to_ProductListType() async {
        // given
        let decodedType = ProductList.self
        MockURLProtocol.responseWithDTO(type: .product)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<ProductList, OpenMarketAPIError> = await sut.request(
            decodedType,
            router: .inquiryProduct(id: 32)
        )
        
        switch result {
        case .success(let string):
            debugPrint(string)
            XCTFail()
        case .failure(let error):
            // then
            debugPrint(error)
            XCTAssertEqual(error, OpenMarketAPIError.invalidData)
        }
    }
    
    // MARK: - health check test

    func test_healthCheck_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .healthCheck)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<Bool, OpenMarketAPIError> = await sut.healthCheck()
        
        switch result {
        case .success(let response):
            debugPrint("response = \(response)")
            XCTAssertTrue(response)
        case .failure(let error):
            debugPrint("error = \(error.localizedDescription)")
            XCTFail()
        }
    }
    
    func test_healthCheck_responseCode_200_and_failure() async {
        // given
        MockURLProtocol.responseWithDTO(type: .failHealthCheck)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<Bool, OpenMarketAPIError> = await sut.healthCheck()
        
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, OpenMarketAPIError.failHealthChecker)
        }
    }
    
    func test_healthCheck_responseCode_400_and_failure() async {
        // given
        MockURLProtocol.responseWithDTO(type: .healthCheck)
        MockURLProtocol.responseWithStatusCode(code: 400)

        // when
        let result: Result<String, OpenMarketAPIError> = await sut.request(
            String.self,
            router: .healthChecker
        )
        
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            // then
            debugPrint(error.localizedDescription)
            XCTAssertEqual(error, OpenMarketAPIError.responseFail)
        }
    }
    
    // MARK: - fetch product list test

    func test_inquiryProductList_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .productList)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<ProductList, OpenMarketAPIError> = await sut.inquiryProductList(
            pageNumber: 1,
            itemsPerPage: 20
        )
        
        /* first item
        {
            "id": 2454,
            "vendor_id":48,
            "vendorName":"zhilly",
            "name":"애플 매직 키보드",
            "description":"애플 매직 키보드 판매합니다. S급!!\n비닐만 뜯은 새제품입니다~\n\n영문 각인, 풀배열, Touch ID 탑재 버전",
            "thumbnail":"https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/48/20240130/6809fffcbf1811eeaa7e6f3376c52955_thumb.png",
            "currency":"KRW",
            "price":150000.0,
            "bargain_price":150000.0,
            "discounted_price":0.0,
            "stock":0,
            "created_at":"2024-01-30T00:00:00",
            "issued_at":"2024-01-30T00:00:00"
        }
        */
        
        switch result {
        case .success(let response):
            debugPrint("response = \(response)")
            
            let firstItem: Product = response.pages.first!
            
            XCTAssertEqual(firstItem.id, 2454)
            XCTAssertEqual(firstItem.vendorID, 48)
            XCTAssertEqual(firstItem.vendorName, "zhilly")
            XCTAssertEqual(firstItem.name, "애플 매직 키보드")
            XCTAssertEqual(firstItem.price, 150000.0)
        case .failure(let error):
            debugPrint("error = \(error.localizedDescription)")
            XCTFail()
        }
    }
    
    // MARK: - fetch product test
    
    func test_inquiryProduct_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .product)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<Product, OpenMarketAPIError> = await sut.fetchProduct(id: 1)
        
        switch result {
        case .success(let item):
            // then
            debugPrint(item)
            XCTAssertEqual(item.id, 2454)
            XCTAssertEqual(item.name, "애플 매직 키보드")
            XCTAssertEqual(item.vendors?.name, "zhilly")
            XCTAssertEqual(item.vendors?.id, 48)
        case .failure(let error):
            debugPrint(error)
            XCTFail()
        }
    }
    
    // MARK: - create product test
    
    func test_createProduct_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .createProduct)
        MockURLProtocol.responseWithStatusCode(code: 200)
        let testParams: ParamsProduct = .init(name: "test",
                                              description: "test",
                                              price: 0,
                                              currency: .KRWString,
                                              secret: "test_secret")
        let testImageDatas: [Data] = [Data(), Data(), Data()]
        
        // when
        let result: Result<Data, OpenMarketAPIError> = await sut.createProduct(testParams, testImageDatas)
        
        switch result {
        case .success(let item):
            guard let decode = JSONDecoder.decodeData(data: item, to: Product.self) else {
                XCTFail()
                return
            }
            
            // then
            debugPrint(decode)
            XCTAssertEqual(decode.id, 2454)
            XCTAssertEqual(decode.name, "애플 매직 키보드")
            XCTAssertEqual(decode.vendors?.name, "zhilly")
            XCTAssertEqual(decode.vendors?.id, 48)
        case .failure(let error):
            debugPrint(error)
            XCTFail()
        }
    }
    
    func test_createProduct_invalidData_responseCode_200_and_failure() async {
        // given
        MockURLProtocol.responseWithDTO(type: .invalidData)
        MockURLProtocol.responseWithStatusCode(code: 200)
        let testParams: ParamsProduct = .init(name: "test",
                                          description: "test",
                                          price: 0,
                                          currency: .KRWString,
                                          secret: "test_secret")
        
        // when
        let result: Result<Data, OpenMarketAPIError> = await sut.createProduct(testParams, [])
        
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            // then
            debugPrint(error)
            XCTAssertEqual(error, OpenMarketAPIError.responseFail)
        }
    }
    
    // MARK: - delete method test

    func test_inquiryDeleteURI_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .deleteURI)
        MockURLProtocol.responseWithStatusCode(code: 200)
        let mockDeleteURI: String = "/api/products/testDeleteURI="
        
        // when
        let result: Result<String, OpenMarketAPIError> = await sut.inquiryDeleteURI(id: 2454)
        
        switch result {
        case .success(let deleteURI):
            // then
            XCTAssertEqual(deleteURI, mockDeleteURI)
        case .failure(let error):
            debugPrint(error)
            XCTFail()
        }
    }
    
    func test_inquiryDeleteURI_responseCode_400_and_failure() async {
        // given
        MockURLProtocol.responseWithDTO(type: .deleteURI)
        MockURLProtocol.responseWithStatusCode(code: 400)
        
        // when
        let result: Result<String, OpenMarketAPIError> = await sut.inquiryDeleteURI(id: 2454)
        
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            // then
            XCTAssertEqual(error, OpenMarketAPIError.responseFail)
        }
    }
    
    func test_deleteProduct_responseCode_200_and_success() async {
        // given
        MockURLProtocol.responseWithDTO(type: .product)
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // when
        let result: Result<Bool, OpenMarketAPIError> = await sut.deleteProduct(path: "testDeleteURI")
        
        switch result {
        case .success(let result):
            // then
            XCTAssertTrue(result)
        case .failure:
            XCTFail()
        }
    }
    
    func test_deleteProduct_responseCode_400_and_failure() async {
        // given
        MockURLProtocol.responseWithDTO(type: .invalidData)
        MockURLProtocol.responseWithStatusCode(code: 400)
        
        // when
        let result: Result<Bool, OpenMarketAPIError> = await sut.deleteProduct(path: "testDeleteURI")
        
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            // then
            XCTAssertEqual(error, OpenMarketAPIError.responseFail)
        }
    }
}
