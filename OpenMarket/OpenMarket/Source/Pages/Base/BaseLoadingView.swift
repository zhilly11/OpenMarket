//  OpenMarket - BaseLoadingView.swift
//  Created by zhilly on 2024/01/18

import UIKit

import Lottie
import Then
import SnapKit

class BaseLoadingView: BaseView {
    private let loadingAnimation: LottieAnimation? = LottieAnimation.named("LoadingLottie")
    lazy var loadingView: LottieAnimationView = .init(animation: loadingAnimation).then {
        $0.loopMode = .loop
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 20
    }
    
    override func setupView() {
        super.setupView()
        self.alpha = 0.6
        self.backgroundColor = .clear
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.addSubview(loadingView)

        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(150)
        }
    }
}

import SwiftUI
struct BaseLoadingViewPreview: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            let view = BaseLoadingView()
            return view
        }
        .previewLayout(.sizeThatFits)
    }
}
