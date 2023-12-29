//
//  HMPaddingLabel.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

@IBDesignable

/// 带内边距的Label
public class HMPaddingLabel: UILabel {
        
    /// 文本内边距
    public var padding: UIEdgeInsets = .zero
    
    public override func drawText(in rect: CGRect) {
        let textRext = rect.inset(by: padding)
        super.drawText(in: textRext)
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRext = bounds.inset(by: padding)
        var rect = super.textRect(forBounds: textRext, limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= padding.left
        rect.origin.y -= padding.top
        rect.size.width += padding.left + padding.right
        rect.size.height = rect.size.height + padding.top + padding.bottom
        return rect
    }
}
