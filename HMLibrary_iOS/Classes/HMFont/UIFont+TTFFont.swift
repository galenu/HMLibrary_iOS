//
//  UIFont+TTFFont.swift
//  TTFFont_iOS
//
//  Created by CNCEMN188807 on 2023/12/28.
//

import UIKit

extension UIFont {
    
    /// 创建OpenSans字体
    /// - Parameters:
    ///   - name: OpenSans字体名字
    ///   - size: 字体大小
    /// - Returns: UIFont
    public static func font(_ name: TTFFontName, size: CGFloat) -> UIFont {
        return TTFFont.font(name, size: size)
    }
}

