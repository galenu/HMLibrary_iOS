//
//  HMWeakOject.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

/// 弱引用对象包装器
final public class HMWeakOject<T>: Hashable where T: AnyObject {
    
    private let objectHashValue: Int
    public private(set) weak var object: T?
    
    public init(_  object: T) {
        self.objectHashValue = ObjectIdentifier(object).hashValue
        self.object = object
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(self.objectHashValue)
    }

    public static func == (lhs: HMWeakOject<T>, rhs: HMWeakOject<T>) -> Bool {
      return lhs.objectHashValue == rhs.objectHashValue
    }
}
