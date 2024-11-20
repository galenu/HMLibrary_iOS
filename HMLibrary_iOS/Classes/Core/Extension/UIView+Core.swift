//
//  UIView+Core.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/26.
//

import UIKit
import SnapKit

private var kShadowLayer: Void?
extension UIView {
    
    /// 圆角位置
    public enum HMCornerPosition: Int {
        case bottomRight = 0
        case topRight = 1
        case bottomLeft = 2
        case topLeft = 3
    }
    
    /// 分割线位置
    public enum HMSeparatePosition: Int {
        case top = 0
        case bottom = 1
        case left = 2
        case right = 3
        case all = 4
    }
    
    /// 阴影Layer
    public var shadowLayer: CALayer? {
        get {
            return objc_getAssociatedObject(self, &kShadowLayer) as? CALayer
        }
        set {
            objc_setAssociatedObject(self, &kShadowLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 给某个位置设置圆角
    /// - Parameters:
    ///   - positions: 圆角位置
    ///   - radius: 圆角弧度
    public func setCorner(_ positions: [HMCornerPosition] = [.bottomRight, .topRight, .bottomLeft, .topLeft],
                          radius: CGFloat = 12) {
        layer.cornerRadius = radius
        
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createCornerMask(positions))
        if #available(iOS 11.0, *) {
            layer.maskedCorners = maskedCorners
        } else {
            
        }
    }
    
    /// 给view的layer添加shadowLayer阴影/圆角层
    /// - Parameters:
    ///   - shadowRadius: 阴影偏移
    ///   - shadowRadius: 阴影radius
    ///   - shadowColor: 阴影色
    ///   - shadowOpacity: shadowLayer透明度
    ///   - cornerRadius: shadowLayer圆角
    ///   - bounds: shadowLayer大小
    public func addShadowCorner(shadowOffset: CGSize = .zero,
                                shadowRadius: CGFloat = 12,
                                shadowColor: UIColor? ,
                                shadowOpacity: Float = 1,
                                borderColor: UIColor? = nil,
                                cornerRadius: CGFloat? = 12,
                                bounds: CGRect) {
        self.shadowLayer?.removeFromSuperlayer()
        self.shadowLayer = nil
        self.layer.masksToBounds = false
        let shadowLayer = CAShapeLayer()
        shadowLayer.masksToBounds = false
        shadowLayer.shadowColor = shadowColor?.cgColor
        if let borderColor = borderColor {
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
        }
        shadowLayer.backgroundColor = self.backgroundColor?.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.bounds = bounds
        shadowLayer.anchorPoint = CGPoint(x: 0, y: 0)
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            shadowLayer.cornerRadius = cornerRadius
        }
        self.layer.insertSublayer(shadowLayer, at: 0)
        self.shadowLayer = shadowLayer
    }
    
    /// 添加分割线
    @discardableResult
    func addSeparateLine(color: UIColor?,
                         margin: CGFloat = 16,
                         size: CGFloat = 1,
                         position: HMSeparatePosition = .bottom,
                         offset: CGFloat = 0) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        self.addSubview(line)
        switch position {
        case .top:
            line.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(margin)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(offset)
                make.height.equalTo(size)
            }
        case .bottom:
            line.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(margin)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(offset)
                make.height.equalTo(size)
            }
        case .left:
            line.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(offset)
                make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(margin)
                make.width.equalTo(size)
            }
        case .right:
            line.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-offset)
                make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(margin)
                make.width.equalTo(size)
            }
        default:
            break
        }
        return line
    }
    
    /// 开始旋转动画
    public func startRotateAnimation(duration: CGFloat = 0.5) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.toValue = Double.pi * 2.0
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "RotateAnimation")
    }
    
    /// 结束旋转动画
    public func stopRotateAnimation() {
        self.layer.removeAnimation(forKey: "RotateAnimation")
    }
    
    /// 开始抖动动画
    public func startShakeAnimation(repeatCount: Float = 3, duration: CGFloat = 0.07) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-3, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(3, 0, 0))
        ]
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        animation.duration = duration
        self.layer.add(animation, forKey: "ShakeAnimation")
    }
    
    /// 结束抖动动画
    public func stopShakeAnimation() {
        self.layer.removeAnimation(forKey: "ShakeAnimation")
    }
}

extension UIView {
    
    private func parseCornerPosition(_ position: HMCornerPosition) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[position.rawValue]
    }
    
    private func createCornerMask(_ positions: [HMCornerPosition]) -> UInt {
        return positions.reduce(0, { (a, b) -> UInt in
            return a + parseCornerPosition(b).rawValue
        })
    }
}
