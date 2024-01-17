//  OpenMarket - BaseTextField.swift
//  Created by zhilly on 2024/01/10

import UIKit

import SnapKit
import Then

class BaseTextField: BaseView {
    private let titleLabel: UILabel = .init().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .subheadline)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
        $0.text = "Title"
    }
    
    let textField: UITextField = .init().then {
        $0.placeholder = "Content"
        $0.font = .preferredFont(forTextStyle: .body)
        $0.borderStyle = .none
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextField()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        textField.addLeftPadding()
        
        [titleLabel, textField].forEach(addSubview(_:))
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func setupTextField() {
        let trait = textField.traitCollection
        
        trait.performAsCurrent {
            textField.layer.borderColor = UIColor.customTextField.cgColor
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
