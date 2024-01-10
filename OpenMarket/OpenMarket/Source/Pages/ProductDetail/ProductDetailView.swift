//  OpenMarket - ProductDetailView.swift
//  Created by zhilly on 2024/01/05

import UIKit

import SnapKit
import Then

final class ProductDetailView: BaseView {
    
    private let contentScrollView = UIScrollView().then { make in
        make.isScrollEnabled = true
        make.backgroundColor = .customBackground
        make.contentInsetAdjustmentBehavior = .never
    }
    
    let imageScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let pageControl = UIPageControl().then {
        $0.tintColor = .white
        $0.numberOfPages = 5
        $0.currentPage = 2
        $0.backgroundColor = .clear
    }
    
    private var imageViews = [UIImageView]()
    
    let profileView = ProfileView()
    
    let nameLabel = UILabel().then {
        let preferredFont = UIFont.preferredFont(forTextStyle: .title3)
        let boldFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
        $0.text = "상품명"
    }
    
    let createdAtLabel = UILabel().then {
        let text = "2023-08-15"
        let attributeString = NSMutableAttributedString(string: text)
        
        attributeString.addAttribute(.underlineStyle,
                                     value: 1,
                                     range: NSRange.init(location: 0, length: text.count))
        
        $0.attributedText = attributeString
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .systemGray
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "상품 설명"
        $0.font = .preferredFont(forTextStyle: .body)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    let footerView = ProductDetailFooterView()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let safeArea = self.safeAreaLayoutGuide
        
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
        items.forEach { Image in
            let imageView = UIImageView()
            imageView.setImageUrl(Image.url)
            self.imageViews.append(imageView)
        }
        
        addContentScrollView()
        setupPageControl()
    }
    
    private func addContentScrollView()  {
        for i in 0..<imageViews.count {
            let imageView = self.imageViews[safe: i] ?? UIImageView()
            let xPos = imageScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos,
                                     y: 0,
                                     width: imageScrollView.bounds.width,
                                     height: imageScrollView.bounds.height)
            
            imageScrollView.addSubview(imageView)
            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
    private func setupPageControl()  {
        self.pageControl.numberOfPages = self.imageViews.count
    }
    
    func setPageControlSelectedPage(currentX: CGFloat) {
        let currentX = currentX / imageScrollView.frame.size.width
        var currentPage = 0
        
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
