//  OpenMarket - ProductCell.swift
//  Created by zhilly on 2023/03/23

import UIKit

import SnapKit
import Then

final class ProductCell: UITableViewCell, ReusableView {
    
    // MARK: - UI Component

    private let thumbnail = UIImageView().then {
        $0.image = UIImage(systemName: "rays")
        $0.tintColor = .systemGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .title1)
    }
    
    private let priceLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private let stockLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillProportionally
        $0.alignment = .center
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = UIImage(systemName: "rays")
        stockLabel.textColor = .label
    }
    
    // MARK: - Setup

    private func setupViews() {
        self.backgroundColor = .customBackground
        
        [nameLabel, priceLabel, stockLabel].forEach(labelStackView.addArrangedSubview(_:))
        [thumbnail, labelStackView].forEach(contentStackView.addArrangedSubview(_:))
        [contentStackView].forEach(contentView.addSubview(_:))
        
        thumbnail.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.leading.equalTo(contentView.layoutMarginsGuide)
            $0.bottom.trailing.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    func configure(with item: Product) {
        nameLabel.text = "\(item.name)"
        displayPrice(currency: item.currency, price: item.price, bargainPrice: item.bargainPrice)
        displayStock(stock: item.stock)
        thumbnail.setImageUrl(item.thumbnail)
    }
    
    // MARK: - Methods

    private func displayStock(stock: Int) {
        if stock > 0 {
            stockLabel.text = "잔여수량 : \(stock)"
            return
        }
        
        stockLabel.text = "품절"
        stockLabel.textColor = .systemOrange
    }
    
    private func displayPrice(currency: Currency, price: Double, bargainPrice: Double) {
        let priceText: String = currency.symbol + " " + price.convertNumberFormat()
        let bargainText: String = currency.symbol + " " + bargainPrice.convertNumberFormat()
        
        if priceText == bargainText {
            priceLabel.text = priceText
            return
        }
        
        priceLabel.text = priceText + "  " + bargainText
        priceLabel.attributedText = priceLabel.text?.strikeThrough(length: priceText.count, color: .red)
    }
}
