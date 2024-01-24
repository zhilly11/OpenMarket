//  OpenMarket - BaseViewController.swift
//  Created by zhilly on 2023/12/30

import UIKit

import RxSwift

class BaseViewController: UIViewController {

    // MARK: - Property
    
    let disposeBag: DisposeBag = .init()
    
    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Setup Method
    
    func configure() {
        setupView()
        setupLayout()
        setupBind()
    }
    
    func setupView() {
        view.backgroundColor = .customBackground
        setupNavigationBar(color: .customBackground)
    }
    
    func setupLayout() { }
    
    func setupBind() { }
}
