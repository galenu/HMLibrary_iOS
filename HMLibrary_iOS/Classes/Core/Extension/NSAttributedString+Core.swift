//
//  NSAttributedString+Core.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/3/11.
//

import UIKit

/// 富文本样式
public struct HMAttributedStringStyle {
    
    /// 字体
    public var font: UIFont
    
    /// 颜色
    public var textColor: UIColor?
    
    public init(font: UIFont, textColor: UIColor?) {
        self.font = font
        self.textColor = textColor
    }
}

extension NSAttributedString {
    
    /// 向富文本中插入图片，将[img]标签替换成图片
    /// - Parameters:
    ///   - string: 富文本字符串
    ///   - images: 图片
    ///   - styles: 字符串以[img]分割后每段的样式，默认第一段为总体样式
    ///   - imageBounds: 图片的bounds
    ///   - separator: 分割标签[img]
    /// - Returns: NSMutableAttributedString
    public static func imageAttributedString(_ string: String,
                                             images: [UIImage?],
                                             styles: [HMAttributedStringStyle],
                                             imageBounds: CGRect = CGRect(x: 0, y: -4, width: 18, height: 18),
                                             separator: String = "[img]") -> NSMutableAttributedString {

        let totalText = NSMutableAttributedString()
        // 按[img]标签分割
        let strings = string.components(separatedBy: separator)
        if string.isEmpty {
            return totalText
        }
        // 默认样式
        guard let defaultStyle = styles.first else { return totalText }
        
        for index in 0 ..< strings.count {
            let text = NSMutableAttributedString(string: strings[index])
            
            let style = styles.safeValue(index) ?? defaultStyle
            text.addAttributes([.font: style.font,
                                .foregroundColor: style.textColor ?? .white],
                               range: NSMakeRange(0, text.length))
            totalText.append(text)
            
            // 拼接图片
            if let tmpImage = images.safeValue(index), let image = tmpImage {
                let imageAttach = NSTextAttachment()
                imageAttach.image = image
                imageAttach.bounds = imageBounds
                let imageString = NSAttributedString(attachment: imageAttach)
                totalText.append(imageString)
            }
        }
        return totalText
    }
}
