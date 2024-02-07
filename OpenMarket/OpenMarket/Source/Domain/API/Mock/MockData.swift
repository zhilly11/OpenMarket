//  OpenMarket - MockData.swift
//  Created by zhilly on 2024/02/07

import Foundation

struct MockData {
    static var product: Product {
        return JSONDecoder.decodeFile(Product.self,
                                      fileName: MockURLProtocol.MockDTOType.product.fileName)!
    }
    
    static var productList: ProductList {
        return JSONDecoder.decodeFile(ProductList.self,
                                      fileName: MockURLProtocol.MockDTOType.productList.fileName)!
    }
}
