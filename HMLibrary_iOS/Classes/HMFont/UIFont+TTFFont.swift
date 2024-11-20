//
//  UIFont+TTFFont.swift
//  TTFFont_iOS
//
//  Created by CNCEMN188807 on 2023/12/28.
//

import UIKit

extension UIFont {
    
    /// 初始化自定义字体
    /// - Parameters:
    ///   - name: 字体name
    ///   - size: 字体size
    /// - Returns: UIFont
    public static func font(_ name: TTFFontName, size: CGFloat) -> UIFont {
        return TTFFont.font(name, size: size)
    }
    
    /// 初始化自定义字体
    /// - Parameters:
    ///   - nameWeight: 字体name和weight
    ///   - size: 字体size
    /// - Returns: UIFont
    public static func font(_ weight: TTFFontWeight, size: CGFloat) -> UIFont {
        return TTFFont.font(weight, size: size)
    }
}

