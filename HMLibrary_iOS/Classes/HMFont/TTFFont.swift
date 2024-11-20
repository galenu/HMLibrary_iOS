//
//  TTFFont.swift
//  TTFFont_iOS
//
//  Created by CNCEMN188807 on 2023/12/28.
//

import Foundation

/// OpenSans 字体字重
public enum TTFFontWeight: String {
    
    case os300 = "OpenSans-Light"
    
    case os400 = "OpenSans-Regular"
    
    case os600 = "OpenSans-Semibold"
        
    case os700 = "OpenSans-Bold"
        
    case os800 = "OpenSans-ExtraBold"
        
    case bn400 = "BebasNeue-Regular"
    
    case rg500 = "RocGrotesk-WideMedium"
    
    case rg700 = "RocGrotesk-WideExtraBold"
}

/// OpenSans名称
public enum TTFFontName: String {
    
    case osLight = "OpenSans-Light"
    
    case osRegular = "OpenSans-Regular"
    
    case osSemibold = "OpenSans-Semibold"
        
    case osBold = "OpenSans-Bold"
        
    case osExtraBold = "OpenSans-ExtraBold"
    
    case bnRegular = "BebasNeue-Regular"
    
    case rgMedium = "RocGrotesk-WideMedium"
    
    case rgExtraBold = "RocGrotesk-WideExtraBold"
    
    case rgCondensedBold = "RocGrotesk-CondensedBold"
}

public class TTFFont {
    
    /// 字体比例  如字体需要根据屏幕大小放大 需要设置对应比例
    public static var fontScale: CGFloat = 1.0
    
    /// 字体向下取整小数位数
    public static var fontSizeDecimalDigits: UInt = 1
    
    /// 注册OpenSans字体
    public static func register() {
        guard var dirPath = Bundle(for: TTFFont.self).path(forResource: "HMLibrary_iOS.bundle", ofType: nil) else { return }
        dirPath = dirPath.appending("/HMFont")
        self.registerFont(dirPath: dirPath)
    }
    
    /// 注册文件夹路径下的所有自定义ttf/otf字体
    /// - Parameter dirPath: 字体所处文件夹的路径
    /// - Returns: Bool
    @discardableResult
    public static func registerFont(dirPath: String?) -> Bool {
        guard let dirPath = dirPath else { return false }
        guard let fontNames = try? FileManager.default.contentsOfDirectory(atPath: dirPath) else {
            return false
        }
        fontNames.forEach { fontName in
            if fontName.contains(".ttf") || fontName.contains(".otf") {
                registerFont(directoryPath: dirPath, fontName: fontName)
            }
        }
        return true
    }
    
    /// 初始化自定义字体
    /// - Parameters:
    ///   - name: 字体name
    ///   - size: 字体size
    /// - Returns: UIFont
    public static func font(_ name: TTFFontName, size: CGFloat) -> UIFont {
        // 只保留1位小数，剩余小数向上取整
        let fontSize = (size * fontScale).roundDown(fontSizeDecimalDigits)
        let font = UIFont(name: name.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        return font
    }
    
    /// 初始化自定义字体
    /// - Parameters:
    ///   - nameWeight: 字体name和weight
    ///   - size: 字体size
    /// - Returns: UIFont
    public static func font(_ weight: TTFFontWeight, size: CGFloat) -> UIFont {
        // 只保留1位小数，剩余小数向上取整
        let fontSize = (size * fontScale).roundDown(fontSizeDecimalDigits)
        let font = UIFont(name: weight.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)
        return font
    }
}

extension TTFFont {
    
    @discardableResult
    /// 注册自定义ttf/otf字体
    /// - Parameters:
    ///   - directoryPath: 字体的文件夹路径
    ///   - fontName: 字体名称
    /// - Returns: Bool
    static func registerFont(directoryPath: String, fontName: String) -> Bool {
        let url = URL(fileURLWithPath: directoryPath).appendingPathComponent(fontName)
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            debugPrint("ttf font url error : \(url.absoluteString)")
            return false
        }
        guard let font = CGFont(fontDataProvider) else { return false }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            let message = error.debugDescription
            error?.release()
            debugPrint("ttf font register error: \(message)")
            return false
        }
        return true
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
