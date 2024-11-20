//
//  HMRouteable.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2023/12/30.
//

import URLNavigator

/// RouteTarget协议目的是为了统一参数格式，可能由h5页面打开某一页，h5仅支持url传参数，所以统一用url传参, 禁止context传参 例 "app://login/<account>"
public protocol HMRouteable {

    /// 地址前缀
    var baseUrl: String { get }

    /// 注册viewController的key，如果需要传参，拼接到path里，因为可能由h5页面打开某一页，h5仅支持url传参数，所以统一用url传参, 禁止context传参 例 "app://login/<account>"
    var path: String { get }

    /// 路由传递参数
    var queryParameters: [String: String] { get }
    
    /// 注册路由
    static func register(navigator: Navigator)
}

extension HMRouteable {
        
    func toURLConvertible() -> String {
        let encodeParamters = self.encodeParameters()
        if !encodeParamters.isEmpty {
            return String(format: "%@?%@", self.baseUrl + self.path, encodeParamters)
        }
        
        return self.baseUrl + self.path
    }
    
    fileprivate func encodeParameters() -> String {
        var encodeArray: [String] = []
        for (key, value) in self.queryParameters {
            let encode = String(format: "%@=%@", key, value)
            encodeArray.append(encode)
        }
        return encodeArray.joined(separator: "&")
    }
}
