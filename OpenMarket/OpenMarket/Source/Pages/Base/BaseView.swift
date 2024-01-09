//  OpenMarket - BaseView.swift
//  Created by zhilly on 2024/01/08

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .customBackground
    }
    
    func setupLayout() {
        
    }
}

