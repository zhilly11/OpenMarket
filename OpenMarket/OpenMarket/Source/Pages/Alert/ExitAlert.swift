//  OpenMarket - ExitAlert.swift
//  Created by zhilly on 2023/03/29

import UIKit

final class ExitAlert: UIAlertController {
    
    private let confirmAction: UIAlertAction = .init(
        title: "확인",
        style: .cancel,
        handler: { _ in exit(0) }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(confirmAction)
    }
}
