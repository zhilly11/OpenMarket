//  OpenMarket - AlertFactory.swift
//  Created by zhilly on 2023/03/29

import UIKit

enum AlertKind {
    case success(title: String?, message: String?, action: UIAlertAction? = nil)
    case failure(title: String?, message: String?)
    case exit
}

final class AlertFactory {
    
    private enum Constant {
        static let exitAlertTitle = "종료"
        static let exitAlertMessage = "오픈마켓 서버에 연결을 실패하여 앱을 종료합니다."
    }
    
    static func make(_ alertKind: AlertKind) -> UIAlertController {
        switch alertKind {
        case .success(let title, let message, let action):
            let alert = SuccessAlert(title: title, message: message, preferredStyle: .alert)
            
            if let action = action {
                alert.addAction(action)
                return alert
            }
            
            return alert
        case .failure(let title, let message):
            return FailureAlert(title: title, message: message, preferredStyle: .alert)
        case .exit:
            return ExitAlert(title: Constant.exitAlertTitle,
                             message: Constant.exitAlertMessage,
                             preferredStyle: .alert)
        }
    }
}
