//
//  TTFFont.swift
//  TTFFont_iOS
//
//  Created by CNCEMN188807 on 2023/12/28.
//

import Foundation

/// OpenSans名称
public enum TTFFontName: String {
    
    case osBold = "OpenSans-Bold"
    
    case osBoldItalic = "OpenSans-BoldItalic"
    
    case osExtraBold = "OpenSans-ExtraBold"
    
    case osExtraBoldItalic = "OpenSans-ExtraBoldItalic"
    
    case osItalic = "OpenSans-Italic"
    
    case osLight = "OpenSans-Light"
    
    case osLightItalic = "OpenSans-LightItalic"
    
    case osRegular = "OpenSans-Regular"
    
    case osSemibold = "OpenSans-Semibold"
    
    case osSemiboldItalic = "OpenSans-SemiboldItalic"
}

public class TTFFont {
    
    /// 字体比例  如字体需要根据屏幕大小放大 需要设置对应比例
    public static var fontScale: CGFloat = 1.0
    
    /// 字体向下取整小数位数
    public static var fontSizeDecimalDigits: UInt = 1
    
    /// 注册OpenSans字体
    public static func register() {
        guard var directoryPath = Bundle(for: TTFFont.self).path(forResource: "HMLibrary_iOS.bundle", ofType: nil) else { return }
        let openSansDir = directoryPath.appending("/HMFont")
        UIFont.registerFont(directoryPath: openSansDir)
    }
    
    /// 初始化OpenSans.ttf字体
    /// - Parameters:
    ///   - name: 字体name
    ///   - size: 字体尺寸
    /// - Returns: UIFont
    public static func font(_ name: TTFFontName, size: CGFloat) -> UIFont {
        // 只保留1位小数，剩余小数向上取整
        let fontSize = (size * fontScale).roundDown(fontSizeDecimalDigits)
        let font = UIFont(name: name.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        return font
    }
}

extension CGFloat {
    
    /// 保留decimalDigits位小数  剩余小数丢弃并向下取整
    /// - Parameter decimalDigits: 保留小数位数
    /// - Returns: 向上取整后的数
    fileprivate func roundDown(_ decimalDigits: UInt) -> CGFloat {
        let divisor = pow(CGFloat(10.0), CGFloat(decimalDigits))
        let upValue = floor(CGFloat(self * divisor))
        let result = upValue / divisor
        return result
    }
}
