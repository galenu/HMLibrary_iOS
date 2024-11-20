//
//  HMCacheStorage.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/25.
//

import UIKit
import Cache

/// Cache提供的方法
public class HMCacheStorage {
    
    /// 缓存配置
    private var config: HMCacheConfigable
    
    private var storage: Storage<String, Data>? {
        
        if let _oldDiskConfig = _oldDiskConfig, self.config.isEqualTo(_oldDiskConfig)  { // 创建过storage 比较配置 配置有改变再重新创建
            return _oldStorage
        } else { // 没有则新建
            let diskConfig = DiskConfig(name: config.name, expiry: .never, directory: config.directory, protectionType: .complete)
            _oldDiskConfig = config
            let memoryConfig = MemoryConfig()
            
            let transformer = TransformerFactory.forData()
            _oldStorage = try? Storage<String, Data>(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: transformer)
            return _oldStorage
        }
    }
    /// 旧的Storage
    private var _oldStorage: Storage<String, Data>?
    /// 旧的缓存配置
    private var _oldDiskConfig: HMCacheConfigable?

    public init(config: HMCacheConfigable) {
        self.config = config
    }
}

extension HMCacheStorage: HMCacheable {
    
    public func object(forKey: HMCacheKeyProtocol) -> Data? {
        guard let data = try? self.storage?.object(forKey: forKey.cacheKey) else { return nil }
        return data
    }
    
    public func setObject(_ data: Data, forKey: HMCacheKeyProtocol) {
        try? self.storage?.setObject(data, forKey: forKey.cacheKey)
    }
    
    public func object<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type) -> T? {
        guard let data = self.object(forKey: forKey) else { return nil }
        let result = HMCacheSerializer.formData(data: data, type: type)
        return result
    }
    
    public func setObject(_ object: Codable, forKey: HMCacheKeyProtocol) {
        let data = HMCacheSerializer.toData(object: object)
        self.setObject(data, forKey: forKey)
    }
    
    public func removeObject<T: HMCacheKeyProtocol>(forKey: T) {
        try? self.storage?.removeObject(forKey: forKey.cacheKey)
    }

    public func removeAll() {
        try? self.storage?.removeAll()
    }
    
    public func existsObject<T: HMCacheKeyProtocol>(forKey: T) -> Bool {
        return (try? self.storage?.existsObject(forKey: forKey.cacheKey)) ?? false
        
    }
    
    // MARK: - 异步缓存
    
    public func asyncObject(forKey: HMCacheKeyProtocol, completion: @escaping ((Data) -> Void), failure: ((Error) -> Void)? = nil) {
        self.storage?.async.object(forKey: forKey.cacheKey) { result in
            switch result {
            case let .value(data):
                DispatchQueue.main.async {
                    completion(data)
                }
            case let .error(error):
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
    public func asyncSetObject(_ data: Data, forKey: HMCacheKeyProtocol, completion: (() -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        self.storage?.async.setObject(data, forKey: forKey.cacheKey, completion: { result in
            switch result {
            case .value:
                DispatchQueue.main.async {
                    completion?()
                }
            case let .error(error):
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        })
    }
    
    public func asyncObject<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type, completion: @escaping ((T) -> Void), failure: ((Error) -> Void)? = nil) {
        self.asyncObject(forKey: forKey, completion: { [weak self] data in
            guard let `self` = self else { return }
            self.storage?.async.serialQueue.async {
                let result = HMCacheSerializer.formData(data: data, type: type)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }, failure: failure)
    }
    
    public func asyncSetObject(_ object: Codable, forKey: HMCacheKeyProtocol, completion: (() -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        self.storage?.async.serialQueue.async {
            let data = HMCacheSerializer.toData(object: object)
            self.asyncSetObject(data, forKey: forKey, completion: completion, failure: failure)
        }
    }
    
    public func asyncRemoveObject(forKey: HMCacheKeyProtocol, completion: (() -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        self.storage?.async.removeObject(forKey: forKey.cacheKey) { result in
            switch result {
            case .value:
                DispatchQueue.main.async {
                    completion?()
                }
            case let .error(error):
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
    public func asyncRemoveAll(completion: (() -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        self.storage?.async.removeAll { result in
            switch result {
            case .value:
                DispatchQueue.main.async {
                    completion?()
                }
            case let .error(error):
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
    public func asyncExistsObject(forKey: HMCacheKeyProtocol, completion: ((Bool) -> Void)? = nil) {
        self.storage?.async.existsObject(forKey: forKey.cacheKey) { result in
            switch result {
            case .value(_):
                DispatchQueue.main.async {
                    completion?(true)
                }
            case .error(_):
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
}
