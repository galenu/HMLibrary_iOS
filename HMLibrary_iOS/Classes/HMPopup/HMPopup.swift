//
//  HMPopup.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

/// 弹框类
public class HMPopup {
    
    /// 给vc弹框  默认nil表示获取最顶层的PresentedController
    /// - Parameters:
    ///   - attribute: 弹出框配置
    ///   - vc: 容器vc
    ///   - completion: 弹出完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    public static func show(attribute: HMPopupAttribute,
                            for vc: UIViewController? = nil,
                            completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        self.endEditing()
        
        let mask = HMPopupMaskVC(attribute: attribute)
        let popupView = attribute.popupView
        
        guard let containerVC = self.getContainerVC(vc) else { return mask }
        
        containerVC.present(mask, animated: false) {
            mask.view.addSubview(popupView)
            if let popupVC = attribute.popupVC {
                mask.addChild(popupVC)
            }
            attribute.showPosition(mask)
            mask.view.layoutIfNeeded()
            
            attribute.beforeAnimation?(mask)
            UIView.animate(withDuration: 0.25) {
                attribute.afterAnimation?(mask)
            } completion: { _ in
                completion?()
            }
        }
        return mask
    }
    
    
    /// 消失弹框
    /// - Parameters:
    ///   - mask: 背景遮罩mask
    ///   - completion: 消失完成回调
    public static func dismiss(mask: HMPopupMaskVC, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25) {
            mask.attribute.beforeAnimation?(mask)
        } completion: { _ in
            weak var popupVC = mask.attribute.popupVC
            mask.dismiss(animated: false) {
                popupVC?.removeFromParent()
                completion?()
            }
        }
    }
    
    
    /// 消失弹框
    /// - Parameters:
    ///   - name: 根据显示的name筛选消失的弹框 默认nil表示消失所有显示的弹框
    ///   - vc: 容器vc
    ///   - completion: 消失完成回调
    public static func dismiss(name: String? = nil,
                               for vc: UIViewController? = nil,
                               completion: (() -> Void)? = nil) {
        if let masks = self.allPopupMask(name: name, for: vc) {
            if masks.count < 1 {
                return
            }
            for (index, mask) in masks.enumerated() {
                if index == masks.count - 1 { // 最后一个
                    self.dismiss(mask: mask, completion: completion)
                } else {
                    self.dismiss(mask: mask, completion: nil)
                }
            }
        }
    }
}

extension HMPopup {
    
    /// 弹出Alert 
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - alert: 自定义alert
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    public static func showAlert(name: String? = nil,
                                 _ alert: UIView,
                                 for vc: UIViewController? = nil,
                                 size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width - 30),
                                 offsetX: CGFloat = 0,
                                 offsetY: CGFloat = 0,
                                 dismissWhenTapMask: Bool = true,
                                 completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let attribute = HMPopupAnimationFactory.alert(name: name, popupView: alert, size: size, offsetX: offsetX, offsetY: offsetY)
        attribute.dismissWhenTapMask = dismissWhenTapMask
        let mask = self.show(attribute: attribute, for: vc, completion: completion)
        return mask
    }
    
    /// 从底部弹出actionSheet
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - actionSheet: 自定义actionSheet
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    public static func showActionSheet(name: String? = nil,
                                       _ actionSheet: UIView,
                                       for vc: UIViewController? = nil,
                                       size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width),
                                       offsetX: CGFloat = 0,
                                       offsetY: CGFloat = 0,
                                       dismissWhenTapMask: Bool = true,
                                       completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let attribute = HMPopupAnimationFactory.present(name: name, popupView: actionSheet, size: size, offsetX: offsetX, offsetY: offsetY)
        attribute.dismissWhenTapMask = dismissWhenTapMask
        let mask = self.show(attribute: attribute, for: vc, completion: completion)
        return mask
    }
    
    /// 从右向左push弹出popupView
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - popupView: 弹出的popupView
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    public static func pushPopover(name: String? = nil,
                                 _ popupView: UIView,
                                 for vc: UIViewController? = nil,
                                 size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width),
                                 offsetX: CGFloat = 0,
                                 offsetY: CGFloat = 0,
                                 dismissWhenTapMask: Bool = true,
                                 completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let attribute = HMPopupAnimationFactory.push(name: name, popupView: popupView, size: size, offsetX: offsetX, offsetY: offsetY)
        attribute.dismissWhenTapMask = dismissWhenTapMask
        let mask = self.show(attribute: attribute, for: vc, completion: completion)
        return mask
    }
}
