//
//  HMPopupAnimationFactory.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2023/12/25.
//

import UIKit

public class HMPopupAnimationFactory {
    
    /// 默认alert动画
    public static func alert(name: String? = nil, popupView: UIView, size: HMPopupSize = .layoutFit(leading: 30)) -> HMPopupAttribute {
        let attribute = HMPopupAttribute(name: name, popupView: popupView) { _ in
            // 显示位置
            popupView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                
                switch size {
                case let .layoutFit(leading):
                    make.leading.equalToSuperview().offset(leading)
                case let .size(width, height):
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
        }
        attribute.beforeAnimation = { mask in
            mask.view.backgroundColor = .clear
            popupView.alpha = 0
        }
        attribute.afterAnimation = { mask in
            popupView.alpha = 1
            mask.view.backgroundColor = mask.attribute.maskColor
        }
        return attribute
    }
    
    /// 默认present动画
    public static func present(name: String? = nil, popupView: UIView, size: HMPopupSize = .layoutFit(leading: 0)) -> HMPopupAttribute {
        let attribute = HMPopupAttribute(name: name, popupView: popupView) { _ in
            // 显示位置
            popupView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                switch size {
                case let .layoutFit(leading):
                    make.left.equalToSuperview().offset(leading)
                case let .size(width, height):
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
        }
        attribute.beforeAnimation = { mask in
            mask.view.backgroundColor = .clear
            popupView.transform = CGAffineTransformMakeTranslation(0, popupView.bounds.height)
        }
        attribute.afterAnimation = { mask in
            mask.view.backgroundColor = mask.attribute.maskColor
            popupView.transform = .identity
        }
        return attribute
    }
    
    /// 默认push动画
    public static func push(name: String? = nil, popupView: UIView, size: HMPopupSize = .layoutFit(leading: 0)) -> HMPopupAttribute {
        let attribute = HMPopupAttribute(name: name, popupView: popupView) { _ in
            // 显示位置
            popupView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                switch size {
                case let .layoutFit(leading):
                    make.left.equalToSuperview().offset(leading)
                case let .size(width, height):
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
        }
        attribute.beforeAnimation = { mask in
            mask.view.backgroundColor = .clear
            popupView.transform = CGAffineTransformMakeTranslation(popupView.bounds.width, 0)
        }
        attribute.afterAnimation = { mask in
            mask.view.backgroundColor = .clear
            popupView.transform = .identity
        }
        return attribute
    }
}

