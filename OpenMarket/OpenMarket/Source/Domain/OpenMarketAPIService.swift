//  OpenMarket - OpenMarketAPIService.swift
//  Created by zhilly on 2024/02/04

import Alamofire

protocol OpenMarketAPIService {
    var session: Session { get }
    
    // MARK: - Get

    func healthCheck() async -> Result<Bool, OpenMarketAPIError>
    
    func inquiryProductList(
        pageNumber: Int,
        itemsPerPage: Int,
        searchValue: String?
    ) async -> Result<ProductList, OpenMarketAPIError>
    
    func fetchProduct(id: Int) async -> Result<Product, OpenMarketAPIError>
    
    // MARK: - Post

    func createProduct(
        _ item: ParamsProduct,
        _ images: [Data]
    ) async -> Result<Data, OpenMarketAPIError>
    
    func inquiryDeleteURI(id: Int) async -> Result<String, OpenMarketAPIError>
    
    // MARK: - Patch

    func updateProduct(id: Int)
    
    // MARK: - Delete

    func deleteProduct(path: String) async -> Result<Bool, OpenMarketAPIError>
}
