//  OpenMarket - BaseTextView.swift
//  Created by zhilly on 2024/01/10

import UIKit

import SnapKit
import Then

class BaseTextView: BaseView {
    private let titleLabel: UILabel = .init().then {
        let preferredFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline)
        let boldFont: UIFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
        $0.text = "Title"
    }
    
    let textView: UITextView = .init().then {
        $0.isScrollEnabled = false
        $0.text = Constant.Placeholder.description
        $0.textColor = .customTextField
        $0.font = .preferredFont(forTextStyle: .body)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1.0
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private let contentStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTextField()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [titleLabel, textView].forEach(contentStackView.addArrangedSubview(_:))
        [contentStackView].forEach(addSubview(_:))
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
    }
    
    private func setupTextField() {
        let trait: UITraitCollection = textView.traitCollection
        
        trait.performAsCurrent {
            textView.layer.borderColor = UIColor.customTextField.cgColor
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
