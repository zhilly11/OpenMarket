//  OpenMarket - AlertFactory.swift
//  Created by zhilly on 2023/03/29

import UIKit

enum AlertKind {
    case success(title: String?, message: String?, action: UIAlertAction? = nil)
    case failure(title: String?, message: String?)
    case exit
}

final class AlertFactory {
    static func make(_ alertKind: AlertKind) -> UIAlertController {
        switch alertKind {
        case .success(let title, let message, let action):
            let alert: SuccessAlert = SuccessAlert(title: title,
                                                   message: message,
                                                   preferredStyle: .alert)
            
            if let action = action {
                alert.addAction(action)
            }
            
            return alert
        case .failure(let title, let message):
            return FailureAlert(title: title,
                                message: message,
                                preferredStyle: .alert)
        case .exit:
            return ExitAlert(title: Constant.Message.exit,
                             message: Constant.Message.exitAlertContent,
                             preferredStyle: .alert)
        }
    }
}
