//
//  HMSectionScrollView.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

/// 分组的ScrollView  垂直布局容器
open class HMSectionScrollView: UIScrollView {
    
    /// 内边距
    open var padding: UIEdgeInsets = .zero {
        didSet {
            self.reloadLayout()
        }
    }
    
    open var width: CGFloat = UIScreen.main.bounds.width {
        didSet {
            self.reloadLayout()
        }
    }
    
    open lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    public init() {
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupUI()
    }
    
    private func setupUI() {
        
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        
        self.addSubview(stackView)
        self.reloadLayout()
    }
    
    open func reloadLayout() {
        stackView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(padding.left)
            make.right.equalToSuperview().offset(-padding.right)
            make.top.equalToSuperview().offset(padding.top)
            make.bottom.equalToSuperview().offset(-padding.bottom)
            make.width.equalTo(width - padding.left - padding.right)
        }
    }
    
    /// 添加分组View
    /// - Parameters:
    ///   - view: 分组View
    ///   - nextSpacing: 距离下一个分组view的间距
    public func addRow(_ view: UIView, nextSpacing: CGFloat = 0) {
        self.stackView.addArrangedSubview(view, nextSpacing: nextSpacing)
    }
    
    /// 移除所有行
    public func removeAllRow() {
        self.stackView.removeAllArrangedSubviews()
    }
}

