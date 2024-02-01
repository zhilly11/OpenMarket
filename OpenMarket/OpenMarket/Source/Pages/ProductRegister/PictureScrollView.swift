//  OpenMarket - PictureScrollView.swift
//  Created by zhilly on 2024/01/15

import UIKit

import SnapKit
import Then

final class PictureScrollView: BaseView {
    
    private let imageScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentStackView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    let pictureSelectButton: UIButton = .init().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
        setupButton()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [pictureSelectButton].forEach(contentStackView.addArrangedSubview(_:))
        [contentStackView].forEach(imageScrollView.addSubview(_:))
        [imageScrollView].forEach(addSubview(_:))
        
        imageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        pictureSelectButton.snp.makeConstraints {
            $0.width.height.equalTo(contentStackView.snp.height)
        }
    }
    
    private func setupBorder() {
        let trait = pictureSelectButton.traitCollection
        
        trait.performAsCurrent {
            pictureSelectButton.layer.borderColor = UIColor.customTextField.cgColor
        }
    }
    
    private func setupButton() {
        let imageConfig: UIImage.SymbolConfiguration = .init(font: .preferredFont(forTextStyle: .title2))
        let configuration: UIButton.Configuration = .filled().with {
            $0.image = Constant.Image.camera
            $0.preferredSymbolConfigurationForImage = imageConfig
            $0.baseBackgroundColor = .clear
            $0.baseForegroundColor = .systemGray2
            $0.buttonSize = .large
        }
        
        pictureSelectButton.configuration = configuration
    }
    
    func addImageView(imageData: Data) {
        Task {
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                let imageView: UIImageView = .init().then {
                    $0.contentMode = .scaleAspectFill
                    $0.layer.cornerRadius = 10
                    $0.clipsToBounds = true
                }
                imageView.image = imageView.downsample(imageData: imageData, width: 100, height: 100)
                self.contentStackView.addArrangedSubview(imageView)
                
                imageView.snp.makeConstraints {
                    $0.width.height.equalTo(self.pictureSelectButton.snp.height)
                }
            }
        }
    }
    
    func removeImageViews() {
        contentStackView.arrangedSubviews.forEach { view in
            if !(view is UIButton) {
                view.removeFromSuperview()
            }
        }
    }
}

import SwiftUI
struct PictureScrollViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = PictureScrollView()
            return view
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
