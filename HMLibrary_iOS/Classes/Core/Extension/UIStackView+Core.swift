//
//  UIStackView+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension UIStackView {
    
    /// 设置子内容布局边距
    public override var layoutMargins: UIEdgeInsets {
        didSet {
            self.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    /// 添加view 并设置距离下个view的间距
    /// - Parameters:
    ///   - view: 添加的view
    ///   - nextSpacing: 距离下个view的间距
    public func addArrangedSubview(_ view: UIView, nextSpacing: CGFloat?) {
        self.addArrangedSubview(view)
        if let nextSpacing = nextSpacing {
            if #available(iOS 11.0, *) {
                self.setCustomSpacing(nextSpacing, after: view)
            } else {
                
            }
        }
    }
    
    /// 移除所有的arrangedSubviews
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    /// 添加addArrangedSubview
    public func addArrangedSubviews(_ views : [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}
