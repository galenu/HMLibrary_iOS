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
    
    /// 截取子字符串
    /// - Parameters:
    ///   - startIndex: 开始位置，小于0会从0开始
    ///   - endIndex: 结束位置，大于字符串长度则到字符串末尾为止,结束位置小于开始位置会返回空字符串
    /// - Returns: 截取的字符串
    public func subString(startIndex: Int, endIndex: Int) -> String {
        if startIndex > endIndex {
            return ""
        }
        let start = max(0, startIndex)
        let end = min(endIndex, self.count - 1)
        return (self as NSString).substring(with: NSRange(location: start, length: end - start + 1))
    }
    
    public func subString(location: Int, length: Int) -> String {
        let maxLocation = max(0, location)
        let minLength = min(length, self.count - maxLocation)
        return (self as NSString).substring(with: NSRange(location: maxLocation, length: minLength))
        
    }
    
    /// 用指定符号将字符串分割为多个子字符串 每个字符串的长度由参数指定
    /// 例如： 000c292bbe44 -> 00:0c:29:2b:be:44
    ///
    /// - Parameters:
    ///   - every: 指定子字符串的长度
    ///   - separator: 分隔符
    /// - Returns: string
    public func separate(every: Int, with separator: String) -> String {
        let insertString = String(stride(from: 0, through: Array(self).count, by: every).map {
            Array(Array(self)[$0 ..< min($0 + every, Array(self).count)])
            }.joined(separator: separator))
        
        // 去掉最后一位separator
        let lastSeparator = insertString.subString(location: (insertString.count - separator.count), length: separator.count)
        if lastSeparator == separator {
            return insertString.subString(location: 0, length: insertString.count - separator.count)
        }
        return insertString
    }
}
