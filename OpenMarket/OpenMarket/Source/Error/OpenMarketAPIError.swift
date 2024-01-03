//  OpenMarket - OpenMarketAPIError.swift
//  Created by zhilly on 2023/03/20

import Foundation

enum OpenMarketAPIError: Error {
    case invalidData
    case failHealthChecker
    case inquiryProduct
    case responseFail
    case unknown
}

extension OpenMarketAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "url에 문제가 생겼습니다."
        case .failHealthChecker:
            return "서버로부터 응답이 없습니다."
        case .inquiryProduct:
            return "데이터가 잘못되었습니다."
        case .responseFail:
            return "서버로부터 응답 실패했습니다."
        case .unknown:
            return "알 수 없는 에러"
        }
    }
}
