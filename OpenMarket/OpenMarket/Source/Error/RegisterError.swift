//  OpenMarket - RegisterError.swift
//  Created by zhilly on 2024/01/18

import Foundation

enum RegisterError: Error {
    case unknown
    
    case emptyTitle
    case emptyPrice
    case emptyStock
    case emptyDescription
    
    case wrongTitle
    case wrongPrice
    case wrongStock
    case wrongDescription
    
    case wrongImageCount
}

extension RegisterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "상품명이 비어있습니다."
        case .emptyPrice:
            return "가격이 비어있습니다."
        case .emptyStock:
            return "재고가 비어있습니다."
        case .emptyDescription:
            return "상품 설명이 비어있습니다."
            
        case .wrongTitle:
            return "잘못된 제목 입력입니다."
        case .wrongPrice:
            return "잘못된 가격 입력입니다."
        case .wrongStock:
            return "잘못된 재고 입력입니다."
        case .wrongDescription:
            return "잘못된 상품 설명 입력입니다."
            
        case .wrongImageCount:
            return "이미지는 최소 1장, 최대 5장입니다."
            
        default:
            return ""
        }
    }
}
