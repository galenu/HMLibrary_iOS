//
//  HMAppOrientation.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

/// 转屏方向
public enum HMAppOrientation: String {
    
    /// 竖屏
    case portrait
    /// 左转横屏
    case landscapeLeft
    /// 右转横屏
    case landscapeRight
    /// 所有方向
    case all
}

/// 屏幕方向转屏工具类
public class HMAppOrientationManager {
    
    public static let shared = HMAppOrientationManager()
    
    /// 转屏方向
    public var appOrientation: HMAppOrientation = .portrait
    
    /// 设置app方法
    /// - Parameters:
    ///   - orientation: 方向
    ///   - vc: vc
    public static func setAppOrientation(_ orientation: HMAppOrientation, vc: UIViewController) {
        HMAppOrientationManager.shared.appOrientation = orientation
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            switch orientation {
            case .portrait:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            case .landscapeLeft:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeLeft))
            case .landscapeRight:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            case .all:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
            }
            vc.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            switch orientation {
            case .portrait:
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            case .landscapeLeft:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            case .landscapeRight:
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            case .all:
                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
            }
        }
    }
    
    /// 需要在AppDelegate里实现的方法
    public static func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch HMAppOrientationManager.shared.appOrientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .all:
            return .all
        }
    }
}

//// MARK: - 屏幕旋转
//extension AppDelegate {
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return HMAppOrientationManager.application(application, supportedInterfaceOrientationsFor: window)
//    }
//}

