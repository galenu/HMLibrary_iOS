//
//  NetworkManager.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import Alamofire
import CoreTelephony

/// 网络状态监测管理类
public class NetworkManager {
    
    /// 网络类型
    public enum NetworkType: String {
        /// 未授权
        case unauthorized
        /// 无网络
        case none
        /// 蜂窝网络
        case cellular
        /// 以太网或wifi
        case ethernetOrWiFi
    }
    
    public static let shared = NetworkManager()
    
    /// 判断是否联通网络
    private let reachabilityManager = NetworkReachabilityManager()
    
    /// 判断网络权限
    private let cellularData = CTCellularData()
    
    /// 网络权限是否限制
    private var restrictedState: CTCellularDataRestrictedState
    
    /// 是否联通网络
    public var isReachable: Bool {
        return self.reachabilityManager?.isReachable ?? false
    }

    /// 网络连接类型
    public var networkType: NetworkType = .none
    
    private init() {
        self.restrictedState = cellularData.restrictedState
    }
    
    /// 判断网络是否授权限
    public func isNetworkPermissions() -> Bool {
        return self.networkType == .unauthorized
    }

    /// 开始监听网络变化
    public func startListening() {
        cellularData.cellularDataRestrictionDidUpdateNotifier = { [weak self] state in
            guard let `self` = self else { return }
            if self.restrictedState != state {
                self.restrictedState = state
                self.updateState()
            }
        }
        reachabilityManager?.startListening(onQueue: .global(), onUpdatePerforming: { [weak self] state in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.updateState()
            }
        })
    }

    /// 停止监听网络变化
    public func stopListening() {
        reachabilityManager?.stopListening()
    }
    
    private func updateState() {
        var type: NetworkType = .none
        if let isReachableCell = self.reachabilityManager?.isReachableOnCellular, isReachableCell {
            type = .cellular
        } else if let isReachableWifi = self.reachabilityManager?.isReachableOnEthernetOrWiFi, isReachableWifi {
            type = .ethernetOrWiFi
        } else {
            switch self.restrictedState {
            case .notRestricted: // 网络未受限制
                type = .none
            case .restricted: // 网络受限制
                type = .unauthorized // 这里不能准确的判断出来到底是连上的wifi无网络，还是关闭了网络权限
            default:
                break
            }
        }
        if self.networkType != type {
            self.networkType = type
            NotificationCenter.default.post(name: .Network.didChanged, object: nil)
        }
    }
}

