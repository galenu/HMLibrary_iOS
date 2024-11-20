//
//  UIColor+Core.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/10.
//

import UIKit

public enum GradientDirection: Int {
    case leftToRight,
         rightToLeft,
         upToDown,
         downToUp,
         upLeftToDownRight,
         downRightToUpLeft,
         downLeftToUpRight,
         upRightToDownLeft
}

extension UIColor {
    
    /// Convert hex string (#333333) to UIColor
    public static func hex(_ string: String) -> UIColor {
        let hex = string.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// UIColor的16进制String
    /// - Returns: 16进制String
    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "%06x", rgb)
    }
    
    /// 将颜色转换为图片
    ///
    /// - Returns: UIImage
    public func toImage(size: CGSize,
                        cornerRadius: CGFloat = 0) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()
        setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

    
    /// 生成渐变色图片
    public static func gradientImage(direction: GradientDirection = .upToDown,
                                     colors: [UIColor],
                                     locations: [NSNumber],
                                     size: CGSize) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        switch direction {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .upToDown:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .downToUp:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .upLeftToDownRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .downRightToUpLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .downLeftToUpRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .upRightToDownLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        UIGraphicsBeginImageContext(size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 生成渐变色图片
    public static func gradientColor(direction: GradientDirection = .upToDown,
                                     colors: [UIColor],
                                     locations: [NSNumber],
                                     size: CGSize) -> UIColor {
        let image = UIColor.gradientImage(direction: direction, colors: colors, locations: locations, size: size)
        return UIColor(patternImage: image)
    }
}
