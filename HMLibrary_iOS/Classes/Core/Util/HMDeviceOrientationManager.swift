//
//  HMDeviceOrientationManager.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

/// 屏幕方向转屏工具类
public class HMDeviceOrientationManager {
    
    public static let shared = HMDeviceOrientationManager()
    
    /// 转屏方向
    public var deviceOrientation: UIInterfaceOrientationMask = .portrait
    
    /// 设置app方法
    /// - Parameters:
    ///   - orientation: 方向
    ///   - vc: vc
    public static func setAppOrientation(_ orientation: UIInterfaceOrientationMask, vc: UIViewController) {
        HMDeviceOrientationManager.shared.deviceOrientation = orientation
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            vc.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        }
    }
    
    /// 需要在AppDelegate里实现的方法
    public static func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return HMDeviceOrientationManager.shared.deviceOrientation
    }
}

// MARK: - 屏幕旋转
//extension AppDelegate {
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return HMDeviceOrientationManager.application(application, supportedInterfaceOrientationsFor: window)
//    }
//}

