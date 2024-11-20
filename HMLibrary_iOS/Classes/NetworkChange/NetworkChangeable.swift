//
//  NetworkChangeable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit
import RxSwift
import RxCocoa

public extension Notification.Name {
    /// 网络状态监听的通知
    struct Network {
        /// 网络状态改变
        public static let didChanged =  Notification.Name("HM.Network.didChanged")
    }
}

/// 网络状态改变协议
public protocol NetworkChangeable: AnyObject {
    
    /// 添加网络状态改变的通知
    func addNetworkChangedNotification()
    
    /// 网络状态改变
    func onNetworkChanged(isReachable: Bool, networkType: NetworkManager.NetworkType)
}

private var kNetworkChangeableDisposeBag: Void?
private var kNetworkChangeableIsAddNotification: Void?

/// 网络状态改变协议默认实现
extension NetworkChangeable where Self: NSObject {
    
    private var disposeBag: DisposeBag {
        get {
            return objc_getAssociatedObject(self, &kNetworkChangeableDisposeBag) as? DisposeBag ?? DisposeBag()
        }
        set {
            objc_setAssociatedObject(self, &kNetworkChangeableDisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 是否添加过通知 防止重复监听
    private var isAddNotification: Bool {
        get {
            return objc_getAssociatedObject(self, &kNetworkChangeableIsAddNotification) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &kNetworkChangeableIsAddNotification, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addNetworkChangedNotification() {
        if isAddNotification {
            return
        }
        /// 网络改变后重连
        NotificationCenter.default.rx
            .notification(.Network.didChanged)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.onNetworkChanged(isReachable: NetworkManager.shared.isReachable, networkType: NetworkManager.shared.networkType)
            }).disposed(by: disposeBag)
        isAddNotification = true
    }
    
    
    public func onNetworkChanged(isReachable: Bool, networkType: NetworkManager.NetworkType) { }
}
