//  OpenMarket - Constant.swift
//  Created by zhilly on 2024/01/16

import UIKit.UIImage

enum Constant {
    struct Title {
        static let productList: String = "오픈마켓"
        static let productRegister: String = "내 물건 팔기"
    }
    
    struct LabelTitle {
        static let productName: String = "상품명"
        static let productDescription: String = "상품 설명"
        
        static let title: String = "제목"
        static let price: String = "가격"
        static let stock: String = "재고"
        static let description: String = "자세한 설명"
    }
    
    struct Button {
        static let check: String = "확인"
        static let cancel: String = "취소"
        static let delete: String = "삭제"
        static let edit: String = "수정"
        static let chat: String = "채팅하기"
        static let editSuccess: String = "작성 완료"
    }
    
    struct Image {
        static let empty: UIImage = .init(systemName: "rays") ?? .init()
        static let delete: UIImage = .init(systemName: "trash.fill") ?? .init()
        static let edit: UIImage = .init(systemName: "pencil") ?? .init()
        static let heart: UIImage = .init(systemName: "heart") ?? .init()
        static let profile: UIImage = .init(systemName: "person.crop.circle.fill") ?? .init()
        static let xMark: UIImage = .init(systemName: "xmark") ?? .init()
        static let camera: UIImage = .init(systemName: "camera.fill") ?? .init()
        static let loadingFail: UIImage = .init(systemName: "exclamationmark.triangle.fill") ?? .init()
    }
    
    struct Placeholder {
        static let title: String = "제목"
        static let price: String = "￦ 가격을 입력해주세요."
        static let stock: String = "판매 수량을 입력해주세요."
        static let searchProduct: String = "상품명을 입력하세요."
        static let description: String = """
        오픈마켓에 올릴 게시글 내용을 작성해주세요.
        (판매 금지 물품은 게시가 제한될 수 있어요.)
        
        신뢰할 수 있는 거래를 위해 자세히 적어주세요.
        """
    }
    
    struct Message {
        static let success: String = "성공"
        static let exit: String = "종료"
        static let deleteCompleted: String = "상품 삭제 성공"
        static let registerCompleted: String = "상품 등록 성공"
        static let exitAlertContent: String = "오픈마켓 서버에 연결을 실패하여 앱을 종료합니다."
    }
    
    struct TabBar {
        struct Title {
            static let home: String = "홈"
            static let search: String = "검색"
        }
        
        struct Image {
            static let home: UIImage = .init(systemName: "house") ?? .init()
            static let search: UIImage = .init(systemName: "magnifyingglass.circle") ?? .init()
        }
        
        struct SelectedImage {
            static let home: UIImage = .init(systemName: "house.fill") ?? .init()
            static let search: UIImage = .init(systemName: "magnifyingglass.circle.fill") ?? .init()
        }
    }
}
