//  OpenMarket - SuccessAlert.swift
//  Created by zhilly on 2024/01/18

import UIKit

final class SuccessAlert: UIAlertController {
    
    let checkAction = UIAlertAction(title: "확인", style: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(checkAction)
    }
}
