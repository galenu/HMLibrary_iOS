//
//  HMCodeableDataSerializer.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/25.
//

import UIKit

/// 转换成Data
class HMCacheSerializer {
    
    /// 转换成Data
    /// - Parameter object: 遵循Encodable协议的object
    /// - Returns: Data
    static func toData<T: Encodable>(object: T) -> Data {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(object)
        return data
    }
    
    /// 将Data转换成object
    /// - Parameter data: Data数据
    /// - Returns: 遵循Decodable协议的object
    static func formData<T: Decodable>(data: Data, type: T.Type) -> T {
        let decoder = JSONDecoder()
        let result = try! decoder.decode(T.self, from: data)
        return result
    }
}
