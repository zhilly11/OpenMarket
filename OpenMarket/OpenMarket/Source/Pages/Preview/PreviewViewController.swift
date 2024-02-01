//  OpenMarket - PreviewViewController.swift
//  Created by zhilly on 2023/04/07

import UIKit

import SnapKit
import Then

final class PreviewViewController: UIViewController {
    
    private let imageThumbnail: String
    private let imageView: UIImageView = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        $0.contentMode = .scaleAspectFit
    }
    
    init(thumbnailURL: String) {
        self.imageThumbnail = thumbnailURL
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view = imageView
        view.backgroundColor = .white
//        imageView.load(url: URL(string: imageThumbnail))
        preferredContentSize = imageView.frame.size
    }
}
