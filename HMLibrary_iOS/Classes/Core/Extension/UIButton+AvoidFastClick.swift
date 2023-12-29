//
//  UIButton+AvoidFastClick.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

// MARK: - 避免Button频繁快速点击

fileprivate var nextClickEnableIntervalKey: Void?

extension UIButton {
    
    /// 下一次点击生效时间
    public var nextClickEnableInterval: TimeInterval? {
        get {
            return objc_getAssociatedObject(self, &nextClickEnableIntervalKey) as? TimeInterval
        }
        set {
            if let nextClickEnableInterval = nextClickEnableInterval, nextClickEnableInterval != 0 {
                self.replaceAvoidFastClickMethodIMP()
            }
            objc_setAssociatedObject(self, &nextClickEnableIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIButton {
    
    fileprivate func replaceAvoidFastClickMethodIMP() {
        DispatchQueue.once("\(NSStringFromClass(type(of: self)))_replaceAvoidFastClickMethodIMP") {
            let originalSelector = #selector(UIButton.sendAction(_:to:for:))
            let swizzledSelector = #selector(UIButton.avoidFastClick_sendAction(_:to:for:))
            self.swizzlingMethod(UIButton.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
        }
    }
   
   /// 增加避免快速点击逻辑
    @objc fileprivate func avoidFastClick_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {

        if let nextClickEnableInterval = nextClickEnableInterval {
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + nextClickEnableInterval) { [weak self] in
                guard let `self` = self else { return }
                self.isUserInteractionEnabled = true
            }
        } else {
            avoidFastClick_sendAction(action, to: target, for: event)
        }
    }
}

