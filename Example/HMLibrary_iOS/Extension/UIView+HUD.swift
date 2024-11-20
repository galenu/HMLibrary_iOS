//
//  UIView+HUD.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/3/4.
//

import UIKit
import HMLibrary_iOS

extension UIView {
    
    /// 显示自定义loading
    /// - Parameters:
    ///   - loadingView: 自定义Loading
    ///   - edge: edge
    func showLoading(_ loadingView: UIView = HUDLoadingView(),
                     edgeInsets: UIEdgeInsets = .zero) {
        HUD.showLoadingHUD(loadingView, for: self, edgeInsets: edgeInsets)
    }
    
    /// 隐藏loading
    func hiddenLoading() {
        HUD.hiddenLoadingHUD(for: self)
    }
    
    /// 显示骨架屏
    /// - Parameters:
    ///   - image: 骨架屏图片
    ///   - padding: 图片距离骨架屏的内边距
    ///   - backgroundColor: hud背景
    ///   - edgeInsets: hud内边距
    /// - Returns: HUDSkeletonLoadingView
    @discardableResult
    func showSkeletonLoading(image: UIImage?,
                             padding: UIEdgeInsets = .zero,
                             edgeInsets: UIEdgeInsets = .zero) -> HUDSkeletonLoadingView {
        let skeletonView = HUDSkeletonLoadingView()
        skeletonView.imageView.image = image
        skeletonView.padding = padding
        HUD.showSkeletonHUD(skeletonView, for: self, edgeInsets: edgeInsets)
        return skeletonView
    }
    
    /// 移除view上所有的骨架屏
    func hiddenSkeletonLoading() {
        HUD.hiddenSkeletonHUD(for: self)
    }
    
    /// 显示自定义toast
    /// - Parameters:
    ///   - text: 提示文本
    ///   - duration: 提示时间
    ///   - isInterceptionEvent: 是否响应事件
    ///   - edge: edge
    ///   - completion: toast完成回调
    func showToast(_ text: String,
                   duration: TimeInterval = 2.0,
                   isInterceptionEvent: Bool = false,
                   edgeInsets: UIEdgeInsets = .zero,
                   completion: (() -> Void)? = nil) {
        let toastView = HUDToastView(text: text, duration: duration, completion: completion)
        HUD.showToastHUD(toastView, for: self, isInterceptionEvent: isInterceptionEvent, edgeInsets: edgeInsets)
    }
    
    /// 隐藏自定义toast
    func hiddenToast() {
        HUD.hiddenToastHUD(for: self)
    }
    
    /// 隐藏所有的自定义loading和toast
    func hiddenAllHUD() {
        HUD.hiddenAllHUD(for: self)
    }
}
