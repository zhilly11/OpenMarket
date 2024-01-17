//  OpenMarket - ProductRegisterView.swift
//  Created by zhilly on 2024/01/10

import UIKit

import SnapKit
import Then

final class ProductRegisterView: BaseView {
    
    let pictureScrollView = PictureScrollView()
    let nameTextField = BaseTextField()
    let priceTextField = BaseTextField()
    let stockTextField = BaseTextField()
    let descriptionView = BaseTextView()
    
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
            $0.setTitle("제목")
            $0.textField.placeholder = "제목"
        }
        
        priceTextField.do {
            $0.setTitle("가격")
            $0.textField.placeholder = "￦ 가격을 입력해주세요."
            $0.textField.keyboardType = .numberPad
        }
        
        stockTextField.do {
            $0.setTitle("재고")
            $0.textField.placeholder = "판매 수량을 입력해주세요."
            $0.textField.keyboardType = .numberPad
        }
        
        descriptionView.do {
            $0.setTitle("자세한 설명")
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
