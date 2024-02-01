//  OpenMarket - ProductDetailView.swift
//  Created by zhilly on 2024/01/05

import UIKit

import SnapKit
import Then

final class ProductDetailView: BaseView {
    
    private let contentScrollView: UIScrollView = .init().then {
        $0.isScrollEnabled = true
        $0.backgroundColor = .customBackground
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    let imageScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let pageControl: UIPageControl = .init().then {
        $0.tintColor = .white
        $0.numberOfPages = 5
        $0.currentPage = 2
        $0.backgroundColor = .clear
    }
    
    private var imageViews: [UIImageView] = []
    
    let profileView: ProfileView = .init()
    
    let nameLabel: UILabel = .init().then {
        let preferredFont: UIFont = UIFont.preferredFont(forTextStyle: .title3)
        let boldFont: UIFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
        $0.text = Constant.LabelTitle.productName
    }
    
    let createdAtLabel: UILabel = .init().then {
        let text: String = .init()
        let attributeString: NSMutableAttributedString = .init(string: text)
        
        attributeString.addAttribute(.underlineStyle,
                                     value: 1,
                                     range: NSRange.init(location: 0, length: text.count))
        
        $0.attributedText = attributeString
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .systemGray
    }
    
    let descriptionLabel: UILabel = .init().then {
        $0.text = Constant.LabelTitle.productDescription
        $0.font = .preferredFont(forTextStyle: .body)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    let footerView: ProductDetailFooterView = .init()
    
    private let contentStackView: UIStackView = .init().then {
        $0.axis = .vertical
    }
    
    private let descriptionStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
        
        [contentScrollView, footerView, pageControl].forEach(addSubview(_:))
        
        [imageScrollView,
         profileView,
         descriptionStackView].forEach(contentStackView.addArrangedSubview(_:))
        
        [nameLabel,
         createdAtLabel,
         descriptionLabel].forEach(descriptionStackView.addArrangedSubview(_:))
        
        [contentStackView].forEach(contentScrollView.addSubview(_:))
        
        pageControl.bringSubviewToFront(imageScrollView)
        
        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.height.equalTo(75)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(contentScrollView)
            $0.width.equalTo(contentScrollView)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.width.height.equalTo(safeArea.snp.width)
            $0.top.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(imageScrollView)
            $0.height.equalTo(25)
        }
        
        profileView.snp.makeConstraints {
            $0.height.equalTo(75)
            $0.leading.trailing.equalTo(contentStackView)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
        }
    }
    
    func setupImages(items: [Image]) {
        let imageViewSize = self.safeAreaLayoutGuide.layoutFrame.size
        
        items.forEach { item in
            let imageView: UIImageView = .init()
            imageView.loadImage(item.url, width: imageViewSize.width, height: imageViewSize.height)
            self.imageViews.append(imageView)
        }
        
        addContentScrollView()
        setupPageControl()
    }
    
    private func addContentScrollView()  {
        for i in 0..<imageViews.count {
            let imageView: UIImageView = self.imageViews[safe: i] ?? UIImageView()
            let xPos: CGFloat = imageScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos,
                                     y: 0,
                                     width: imageScrollView.bounds.width,
                                     height: imageScrollView.bounds.height)
            
            imageScrollView.do {
                $0.addSubview(imageView)
                $0.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            }
        }
    }
    
    private func setupPageControl()  {
        self.pageControl.numberOfPages = self.imageViews.count
    }
    
    func setPageControlSelectedPage(currentX: CGFloat) {
        let currentX: CGFloat = currentX / imageScrollView.frame.size.width
        var currentPage: Int = .zero
        
        if !currentX.isNaN && !currentX.isInfinite {
            currentPage = Int(round(currentX))
        }
        
        pageControl.currentPage = currentPage
    }
}

import SwiftUI
struct ProductDetailViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = ProductDetailView()
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
