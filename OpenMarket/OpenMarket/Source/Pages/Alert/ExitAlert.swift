//  OpenMarket - ExitAlert.swift
//  Created by zhilly on 2023/03/29

import UIKit

final class ExitAlert: UIAlertController {
    
    let confirmAction = UIAlertAction(title: "확인", style: .cancel) { _ in
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(confirmAction)
    }
}
