//  OpenMarket - ProductCell.swift
//  Created by zhilly on 2023/03/23

import UIKit
import SnapKit

final class ProductCell: UITableViewCell, ReusableView {
    
    private let thumbnail: UIImageView = {
        
        return UIImageView(image: UIImage(systemName: "rays"))
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
        priceLabel.text = "\(item.price)"
        stockLabel.text = "재고: \(item.stock)개"
        thumbnail.load(url: URL(string: item.thumbnail))
    }
}
