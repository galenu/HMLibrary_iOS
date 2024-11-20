//
//  HMCacheKey.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/25.
//

import UIKit

public protocol HMCacheKeyProtocol {
    
    /// 缓存Key
    var cacheKey: String { get }
}

/// 缓存的key
public struct HMCacheKey: Hashable, Equatable, RawRepresentable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ key: String) {
        self.rawValue = key
    }
}

extension String: HMCacheKeyProtocol {
    
    /// 缓存Key
    public var cacheKey: String {
        return self
    }
}

extension HMCacheKey: HMCacheKeyProtocol {
    
    /// 缓存Key
    public var cacheKey: String {
        return self.rawValue
    }
}
