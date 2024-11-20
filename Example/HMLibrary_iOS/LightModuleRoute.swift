//
//  LightModuleRoute.swift
//  HMLibrary_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import HMLibrary_iOS
import URLNavigator

/// partybox灯模块路由
public enum LightModuleRoute: HMRouteable {
    
    /// light控制
    case lightControl(deviceId: String)
    
    /// light详情
    case lightDetail
}

extension LightModuleRoute {
    
    public var baseUrl: String {
        return "app://lightModule/"
    }
    
    public var path: String {
        switch self {
        case .lightControl:
            return "lightControl"
        case .lightDetail:
            return "lightDetail"
        }
    }
    
    public var queryParameters: [String : String] {
        switch self {
        case let .lightControl(deviceId):
            return ["deviceId" : deviceId]
            
        default:
            return [:]
        }
    }
    
    public static func register(navigator: URLNavigator.Navigator) {
        navigator.register(routeable: LightModuleRoute.lightControl(deviceId: "")) { url, values, context in
            let params = url.queryParameters
            if let deviceId = params["deviceId"] {
                return RouteTestVC(deviceId: deviceId)
            }
            return nil
        }
    }
}
