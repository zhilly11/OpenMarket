//  OpenMarket - ProductDetailFooterView.swift
//  Created by zhilly on 2024/01/08

import UIKit

import SnapKit
import Then

final class ProductDetailFooterView: BaseView {
    
    let heartButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let heartImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        
        $0.setImage(heartImage, for: .normal)
        $0.tintColor = .systemGray
    }
    
    let priceLabel = UILabel().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .title3)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)

        $0.font = boldFont
        $0.text = "00,000원"
    }
    
    let stockLabel = UILabel().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .subheadline)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
        $0.text = "재고 :"
        $0.textColor = .systemGray
    }
    
    let chatButton = UIButton().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .headline)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.titleLabel?.font = boldFont
        $0.setTitle("채팅하기", for: .normal)
        $0.backgroundColor = .main
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let priceStackView = UIStackView().then {
        $0.distribution = .equalCentering
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .separator
    }
    
    private let topSeparatorView = UIView().then {
        $0.backgroundColor = .separator
    }

    override func setupLayout() {
        super.setupLayout()
        
        let safeArea = safeAreaLayoutGuide
        
        [priceLabel,
         stockLabel].forEach(priceStackView.addArrangedSubview(_:))
        
        [topSeparatorView,
         heartButton,
         separatorView ,
         priceStackView,
         chatButton].forEach(addSubview(_:))
        
        topSeparatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        heartButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(safeArea).inset(10)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(10)
            $0.centerY.equalTo(heartButton)
            $0.width.equalTo(1)
            $0.height.equalTo(50)
        }
        
        priceStackView.snp.makeConstraints {
            $0.leading.equalTo(separatorView.snp.trailing).offset(20)
            $0.height.equalTo(50)
            $0.centerY.equalToSuperview()
        }
        
        chatButton.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(40)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(10)
            $0.centerY.equalTo(safeArea.snp.centerY)
        }
    }
}

import SwiftUI
struct ProductDetailFooterViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = ProductDetailFooterView(frame: .zero)
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
