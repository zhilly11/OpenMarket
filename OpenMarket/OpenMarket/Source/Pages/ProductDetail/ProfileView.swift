//  OpenMarket - ProfileView.swift
//  Created by zhilly on 2024/01/08

import UIKit

import SnapKit
import Then

final class ProfileView: BaseView {
    
    let profileImage: UIImageView = .init().then {
        $0.image = Constant.Image.profile
        $0.tintColor = .systemGray
    }
    
    let nameLabel: UILabel = .init().then {
        let preferredFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)
        let boldFont: UIFont = UIFont.boldSystemFont(ofSize: preferredFont.pointSize)
        
        $0.font = boldFont
    }
    
    let venderIDLabel: UILabel = .init().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = .systemGray
    }
    
    private let bottomSeparatorView: UIView = .init().then {
        $0.backgroundColor = .separator
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        [profileImage, nameLabel, venderIDLabel, bottomSeparatorView].forEach(addSubview(_:))
        
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage).offset(5)
            $0.leading.equalTo(profileImage.snp.trailing).offset(5)
        }
        
        venderIDLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(nameLabel)
        }
        
        bottomSeparatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

import SwiftUI
struct ProfileViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = ProfileView(frame: .zero)
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
