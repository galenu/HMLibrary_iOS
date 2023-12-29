//
//  UIButton+ExpandEvent.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit
import Foundation

fileprivate var kEventEdgeInset: Void?

/// 扩大UIView事件响应范围
extension UIView {
    
    /// 扩大UIView的点击区域， 负数为扩大  eg: UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    public var eventInset: UIEdgeInsets? {
        set {
            if let value = newValue, value != .zero {
                self.replacePointInsideMethodIMP()
            }
            objc_setAssociatedObject(self, &kEventEdgeInset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kEventEdgeInset) as? UIEdgeInsets
        }
    }
    
    fileprivate func replacePointInsideMethodIMP() {
        DispatchQueue.once("\(NSStringFromClass(type(of: self)))_replacePointInsideMethodIMP") {
            let originalSelector = #selector(UIView.point(inside:with:))
            let newSelector = #selector(UIView.expand_point(inside:with:))
            self.swizzlingMethod(UIView.self,
                                 originalSelector: originalSelector,
                                 swizzledSelector: newSelector)
       }
   }
    
    /// 扩大点击范围  不能重写hitTest方法，如果有两个叠加的View, 会破坏响应链，顶层的View会被底层的View拦截事件
    @objc fileprivate func expand_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let eventInset = self.eventInset else {
            return self.expand_point(inside: point, with: event)
        }
        if eventInset == .zero || self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.001 {
            return self.expand_point(inside: point, with: event)
        }
       
        return self.bounds.inset(by: eventInset).contains(point)
    }
}
