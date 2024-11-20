//
//  NSObject+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension NSObject {
    
    /// 获取引用对象的地址
    public var address: String {
        return String(format: "%018p", unsafeBitCast(self, to: Int.self))
    }
    
    /// 返回对象的类名称
    public var className: String {
        return String(describing: self.classForCoder)
    }
    
    /// 手机震动反馈效果
    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    /// 替换某个类的方法实现
    /// - Parameters:
    ///   - cls: 交换方法的类
    ///   - originalSelector: 原方法
    ///   - swizzledSelector: 替换的方法
    public func swizzlingMethod(_ cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else { return }
        
        // 在进行Swizzling的时候,需要用class_addMethod先进行判断一下原有类中是否有要替换方法的实现
        let swizzledImp = method_getImplementation(swizzledMethod)
        let swizzledEncoding = method_getTypeEncoding(swizzledMethod)
        
        let didAddMethod = class_addMethod(cls, originalSelector, swizzledImp, swizzledEncoding)
        
        // 如果didAddMethod返回true,说明当前类中没有要替换方法的实现,需要在父类中查找,用method_getImplemetation去获取class_getInstanceMethod的方法实现,再进行class_replaceMethod来实现 Swizzing
        if didAddMethod {
            let originalImp = method_getImplementation(originalMethod)
            let originalEncoding = method_getTypeEncoding(originalMethod)
            
            class_replaceMethod(cls, swizzledSelector, originalImp, originalEncoding)
        } else { // 当前类中有要替换方法的实现, 直接替换
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}
