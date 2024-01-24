//  OpenMarket - FailureAlert.swift
//  Created by zhilly on 2023/03/29

import UIKit

final class FailureAlert: UIAlertController {
    
    private let cancelAction: UIAlertAction = .init(
        title: "확인",
        style: .cancel
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(cancelAction)
    }
}
