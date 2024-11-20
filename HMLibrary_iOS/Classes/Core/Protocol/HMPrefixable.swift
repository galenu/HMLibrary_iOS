//
//  HMPrefixable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

/// hm前缀包装器
public struct HMPrefixableWrapper<Base> {
    
    public var base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

/// hm前缀协议
public protocol HMPrefixable {
    
    associatedtype ValueType
    
    /// 添加hm前缀
    var hm: ValueType { get }
}

extension HMPrefixable {
    
    /// 跟系统难以分辨的变量及方法遵循HMPrefixable协议，给对象添加`hm`属性用于跟系统的做区分
    public var hm: HMPrefixableWrapper<Self> {
        return HMPrefixableWrapper(self)
    }
    
    /// 跟系统难以分辨的类方法遵循HMPrefixable协议，给类添加`hm`属性用于跟系统的做区分
    static var hm: HMPrefixableWrapper<Self>.Type {
        return HMPrefixableWrapper.self
    }
}
