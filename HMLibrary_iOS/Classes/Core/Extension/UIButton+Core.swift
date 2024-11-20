//
//  UIButton+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

/// 图片位置
public enum ImagePosition {
    case top
    case bottom
    case left
    case right
}

extension UIButton {
    
    /// 调整图片 文字的位置和间距
    /// - Parameters:
    ///   - imagePosition: 图片位置
    ///   - imageTitleMargin: 图片 文字的间距
    public func adjustImageTitlePosition(imagePosition: ImagePosition = .left,
                                         imageTitleMargin: CGFloat = 4) {
        
        guard let imageSize = self.imageView?.image?.size,
              let text = self.titleLabel?.text,
              let font = self.titleLabel?.font
        else {
            return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        
        var imageInsets: UIEdgeInsets
        var titleInsets: UIEdgeInsets
        
        switch imagePosition {
        case .top:
            imageInsets = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width)
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + imageTitleMargin),
                                       left: -(imageSize.width),
                                       bottom: 0,
                                       right: 0)
        case .bottom:
            imageInsets = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width)
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + imageTitleMargin),
                                       left: -(imageSize.width),
                                       bottom: 0,
                                       right: 0)
        case .left:
            imageInsets = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: 0)
            titleInsets = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: -imageTitleMargin)
        case .right:
            imageInsets = UIEdgeInsets(top: 0,
                                       left: 0,
                                       bottom: 0,
                                       right: -(titleSize.width * 2 + imageTitleMargin))
            titleInsets = UIEdgeInsets(top: 0,
                                       left: -(imageSize.width * 2),
                                       bottom: 0,
                                       right: 0)
        }
        self.imageEdgeInsets = imageInsets
        self.titleEdgeInsets = titleInsets
    }
}
