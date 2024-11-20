//
//  HMNavigationBar.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit
import SnapKit

@IBDesignable

/// 导航栏
open class HMNavigationBar: UIView {
        
    /// 标题
    public var title: String? {
        didSet{
            self.titleLabel.text = title
        }
    }

    /// 标题UILabel
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    /// 返回按钮
    public var backButton: UIButton!
    /// 返回按钮点击回调
    public var backClickHandler: (() -> Void)?
    
    /// 左边容器UIStackView
    public lazy var leftContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()

    /// 右边容器UIStackView
    public lazy var rightContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()

    public init() {
        super.init(frame: .zero)

        self.setupUI()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        let titleLeftMargin = leftContainer.bounds.width
        let titleRightMargin = rightContainer.bounds.width
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(HMAPP.statusBarHeight)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            if titleRightMargin < titleLeftMargin {
                make.left.equalToSuperview().offset(titleLeftMargin)
            } else {
                make.right.equalToSuperview().offset(-titleRightMargin)
            }
        }
    }
    
    private func setupUI() {

        self.backgroundColor = .clear
        
        self.addSubview(leftContainer)
        leftContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(HMAPP.statusBarHeight)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(0)
        }

        self.addSubview(rightContainer)
        rightContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(HMAPP.statusBarHeight)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(0)
        }
        
        self.addSubview(titleLabel)
        
        self.backButton = self.addLeftItem(image: nil)
        self.backButton.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
    }
}

extension HMNavigationBar {
    
    @discardableResult
    /// 往左边添加图片按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - width: 宽度
    /// - Returns: UIButton
    public func addLeftItem(image: UIImage?,
                            width: CGFloat = 44) -> UIButton {
        let btn = UIButton()
        self.leftContainer.addArrangedSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        btn.adjustsImageWhenHighlighted = false

        if let image = image {
            btn.setImage(image, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            btn.imageView?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        self.layoutSubviews()
        return btn
    }
    
    @discardableResult
    /// 往右边添加图片按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - width: 宽度
    /// - Returns: UIButton
    public func addRightItem(image: UIImage?, width: CGFloat = 44) -> UIButton {

        let btn = UIButton()
        self.rightContainer.addArrangedSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        btn.adjustsImageWhenHighlighted = false
        if let image = image {
            btn.setImage(image, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            btn.imageView?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        self.layoutSubviews()
        return btn
    }
    
    @discardableResult
    /// 往右边添加文本按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - font: 字体
    ///   - titleColor: 颜色
    ///   - width: 宽度
    /// - Returns: UIButton
    public func addRightItem(title: String? = nil,
                             font: UIFont = .systemFont(ofSize: 13, weight: .medium),
                             titleColor: UIColor? = .black,
                             width: CGFloat = 44) -> UIButton {
        
        let btn = UIButton()
        self.rightContainer.addArrangedSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        if let title = title {
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.setTitleColor(titleColor, for: .normal)
            btn.titleLabel?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            btn.titleLabel?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        self.layoutSubviews()
        return btn
    }
    
    @objc private func backBtnClick() {
        self.backClickHandler?()
    }
}

