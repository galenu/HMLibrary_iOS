//
//  String+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension String {
    
    /// 获取文字Size
    /// - Parameters:
    ///   - maxWidth: 最大宽度 传greatestFiniteMagnitude表示获取文本宽度，传具体值表示获取最大高度
    ///   - maxHeight: 最大高度
    ///   - font: 文本字体
    /// - Returns: 文本尺寸
    public func getTextSize(maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude,
                            maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude,
                            font: UIFont) -> CGSize {
        let containerSize =  CGSize(width: maxWidth, height: maxHeight)
        let textSize = self.boundingRect(with: containerSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font: font],
                                         context: nil).size
        return textSize
    }
}
