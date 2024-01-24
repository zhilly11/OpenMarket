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
    
    private let createdAtLabel: UILabel = .init().then {
        let text: String = "2023-08-15"
        let attributeString: NSMutableAttributedString = .init(string: text)
        
        $0.attributedText = attributeString
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .systemGray
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
        
        [nameLabel, createdAtLabel ,priceLabel].forEach(labelStackView.addArrangedSubview(_:))
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
        createdAtLabel.text = "\(item.createdAt.relativeTime_abbreviated)"
        displayPrice(currency: item.currency, price: item.price, bargainPrice: item.bargainPrice)
        thumbnail.setImageUrl(item.thumbnail)
    }
    
    // MARK: - Methods
    
    private func displayPrice(currency: Currency, price: Double, bargainPrice: Double) {
        var priceText: String = .init()
        var bargainText: String = .init()
        
        switch currency {
        case .KRWString:
            priceText = "\(price.convertNumberFormat())원"
            bargainText = "\(bargainPrice.convertNumberFormat())원"
        default:
            priceText = currency.symbol + " " + price.convertNumberFormat()
            bargainText = currency.symbol + " " + bargainPrice.convertNumberFormat()
        }
        
        if priceText == bargainText {
            priceLabel.text = priceText
            return
        }
        
        priceLabel.text = priceText + "  " + bargainText
        priceLabel.attributedText = priceLabel.text?.strikeThrough(length: priceText.count, color: .red)
    }
}
