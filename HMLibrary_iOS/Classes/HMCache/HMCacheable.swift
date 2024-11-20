//
//  HMCacheable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/30.
//

import UIKit

public protocol HMCacheable {
    
    /// 从缓存中获取Data
    func object(forKey: HMCacheKeyProtocol) -> Data?
    
    /// 缓存Data
    func setObject(_ data: Data, forKey: HMCacheKeyProtocol)
    
    /// 缓存Codable对象
    /// - Parameters:
    ///   - forKey: 缓存key
    ///   - type: 缓存Codable对象类型
    /// - Returns: 从缓存中获取的Codable对象
    func object<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type) -> T?
    
    /// 缓存Codable对象
    /// - Parameters:
    ///   - object: 缓存Codable对象
    ///   - forKey: 缓存key
    func setObject(_ object: Codable, forKey: HMCacheKeyProtocol)
    
    /// 移除缓存对象
    func removeObject<T: HMCacheKeyProtocol>(forKey: T)
    
    func removeAll()
    
    func existsObject<T: HMCacheKeyProtocol>(forKey: T) -> Bool
    
    func asyncObject(forKey: HMCacheKeyProtocol, completion: @escaping ((Data) -> Void), failure: ((Error) -> Void)?)
    
    func asyncSetObject(_ data: Data, forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncObject<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type, completion: @escaping ((T) -> Void), failure: ((Error) -> Void)?)
    
    func asyncSetObject(_ object: Codable, forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncRemoveObject(forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncRemoveAll(completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncExistsObject(forKey: HMCacheKeyProtocol, completion: ((Bool) -> Void)?)
}
