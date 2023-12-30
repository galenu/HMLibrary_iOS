//
//  UIFont+Register.swift
//  TTFFont_iOS
//
//  Created by CNCEMN188807 on 2023/12/28.
//

import UIKit

extension UIFont {
    
    @discardableResult
    /// 注册文件夹路径下的所有自定义ttf/otf字体
    /// - Parameter path: 字体所处文件夹的路径
    /// - Returns: Bool
    public static func registerFont(directoryPath: String) -> Bool {
        guard let fontNames = try? FileManager.default.contentsOfDirectory(atPath: directoryPath) else {
            return false
        }
        fontNames.forEach { fontName in
            if fontName.contains(".ttf") || fontName.contains(".otf") {
                registerFont(directoryPath: directoryPath, fontName: fontName)
            }
        }
        return true
    }
    
    @discardableResult
    /// 注册自定义ttf/otf字体
    /// - Parameters:
    ///   - directoryPath: 字体的文件夹路径
    ///   - fontName: 字体名称
    /// - Returns: Bool
    public static func registerFont(directoryPath: String, fontName: String) -> Bool {
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
