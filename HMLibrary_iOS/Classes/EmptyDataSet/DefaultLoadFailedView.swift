//
//  DefaultLoadFailedView.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// 默认加载失败占位View(默认为图片+文字+重试按钮)
open class DefaultLoadFailedView: UIView {
    
    public lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 12
        view.alignment = .center
        view.distribution = .fill
        return view
    }()

    /// 展示图片
    public lazy var imageView = UIImageView(image: nil)

    /// 提示文字
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Load Failed!"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    /// 点击刷新
    public lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Click Refresh", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.eventInset = .init(top: -10, left: -10, bottom: -10, right: -10)
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 图片大小
    public var imageSize: CGSize = CGSize(width: 140, height: 140) {
        didSet {
            imageWidthCons?.update(offset: imageSize.width)
            imageHeightCons?.update(offset: imageSize.height)
        }
    }
    private var imageWidthCons: Constraint?
    private var imageHeightCons: Constraint?
    
    /// y轴偏移
    public var offsetY: CGFloat = -100 {
        didSet {
            offsetYCons?.update(offset: offsetY)
        }
    }
    private var offsetYCons: Constraint?

    /// 点击时是否隐藏EmptyView
    public var isHiddenWhenTap: Bool = true
    
    /// 刷新按钮点击
    public var clickHandler: (() -> Void)?

    public init() {

        super.init(frame: CGRect.zero)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            offsetYCons = make.centerY.equalToSuperview().offset(offsetY).constraint
            make.left.greaterThanOrEqualTo(20)
        }

        imageView.image = UIImage(named: "empty_data", in: getBundle(), compatibleWith: nil)
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            imageWidthCons = make.width.equalTo(imageSize.width).constraint
            imageHeightCons = make.height.equalTo(imageSize.height).constraint
        }
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(btn)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBundle() -> Bundle? {
        guard let path = Bundle(for: Self.self).path(forResource: "HMLibrary_iOS.bundle", ofType: nil) else { return nil }
        let hudBundle = Bundle(path: path)
        return hudBundle
    }
    
    /// 刷新
    @objc private func btnClicked() {
        if self.isHiddenWhenTap {
            self.isHidden = true
        }
        clickHandler?()
    }
}
