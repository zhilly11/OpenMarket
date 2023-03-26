//  OpenMarket - ProductCell.swift
//  Created by zhilly on 2023/03/23

import UIKit
import SnapKit

final class ProductCell: UITableViewCell, ReusableView {
    
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "rays")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        thumbnail.image = UIImage(systemName: "rays")
        stockLabel.textColor = .black
    }
    
    private func setupViews() {
        
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
        thumbnail.load(url: URL(string: item.thumbnail))
    }
    
    private func displayStock(stock: Int) {
        if stock > 0 {
            stockLabel.text = "잔여수량 : \(stock)"
        } else {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        }
    }
    
    private func displayPrice(currency: Currency, price: Double, bargainPrice: Double) {
        let priceText: String = currency.symbol + " " + price.convertNumberFormat()
        let bargainText: String = currency.symbol + " " + bargainPrice.convertNumberFormat()
        
        if priceText == bargainText {
            priceLabel.text = priceText
        } else {
            priceLabel.text = priceText + "  " + bargainText
            priceLabel.attributedText = priceLabel.text?.strikeThrough(length: priceText.count, color: .red)
        }
    }
}
