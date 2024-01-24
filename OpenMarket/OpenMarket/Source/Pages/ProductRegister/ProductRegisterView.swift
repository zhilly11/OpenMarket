//  OpenMarket - ProductRegisterView.swift
//  Created by zhilly on 2024/01/10

import UIKit

import SnapKit
import Then

final class ProductRegisterView: BaseView {
    
    let pictureScrollView: PictureScrollView = .init()
    let nameTextField: BaseTextField = .init()
    let priceTextField: BaseTextField = .init()
    let stockTextField: BaseTextField = .init()
    let descriptionView: BaseTextView = .init()
    
    private let contentScrollView: UIScrollView = .init().then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .customBackground
    }

    private let contentStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    override func setupView() {
        super.setupView()
        
        nameTextField.do {
            $0.setTitle(Constant.LabelTitle.title)
            $0.textField.placeholder = Constant.Placeholder.title
        }
        
        priceTextField.do {
            $0.setTitle(Constant.LabelTitle.price)
            $0.textField.placeholder = Constant.Placeholder.price
            $0.textField.keyboardType = .numberPad
        }
        
        stockTextField.do {
            $0.setTitle(Constant.LabelTitle.stock)
            $0.textField.placeholder = Constant.Placeholder.stock
            $0.textField.keyboardType = .numberPad
        }
        
        descriptionView.do {
            $0.setTitle(Constant.LabelTitle.description)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [pictureScrollView,
         nameTextField,
         priceTextField,
         stockTextField,
         descriptionView].forEach(contentStackView.addArrangedSubview(_:))
        
        [contentStackView].forEach(contentScrollView.addSubview(_:))
        
        [contentScrollView].forEach(addSubview(_:))
        
        pictureScrollView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(contentScrollView)
            $0.width.equalTo(contentScrollView)
        }
    }
}

import SwiftUI
struct ProductRegisterViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = ProductRegisterView()
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
