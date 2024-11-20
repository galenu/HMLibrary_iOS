//
//  HMAPP.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/21.
//

import UIKit

public struct HMAPP {
    
    /// keyWindow
    public var keyWindow: UIWindow {
        return UIApplication.shared.windows.filter{ $0.isKeyWindow }.first ?? UIWindow()
    }
    
    /// 屏宽
    public static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 屏高
    public static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// 导航栏高度
    public static let naviBarHeight: CGFloat = UINavigationController().navigationBar.frame.height
    
    /// 导航高度：含状态栏及导航栏
    public static var naviStatusBarHeight: CGFloat {
        return statusBarHeight + naviBarHeight
    }
    
    /// TabBar高度
    public static var tabBarHeight: CGFloat = UITabBarController().tabBar.frame.height

    /// 顶部安全区
    public static var safeAreaTop: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
        return 0
    }()

    /// 底部安全区
    public static var safeAreaBottom: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }()
}

extension HMAPP {
    
    public static var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    public static func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
