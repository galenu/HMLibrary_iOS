//
//  CALayer+Core.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/3/4.
//

extension CALayer {
    
    /// 给layer添加某个位置的阴影
    public func addShadow(positions: [UIView.HMSeparatePosition],
                          shadowColor: UIColor?,
                          shadowOpacity: Float = 1,
                          shadowOffset: CGSize = .zero,
                          shadowRadius: CGFloat = 12,
                          shadowSize: CGFloat = 3) {
        // 必须要等于NO否则会把阴影切割隐藏掉
        self.masksToBounds = false
        // 阴影颜色
        self.shadowColor = shadowColor?.cgColor
        self.shadowOpacity = shadowOpacity
        // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.shadowOffset = shadowOffset
        // 阴影半径，默认3
        self.shadowRadius = shadowRadius
        
        let shadowPath = CGMutablePath()
        for direction in positions {
            switch direction {
            case .all:
                let shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
                shadowPath.addRect(shadowRect)
            case .top:
                let shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
                shadowPath.addRect(shadowRect)
            case .bottom:
                let shadowRect = CGRect(x: -shadowSize, y: bounds.size.height - shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
                shadowPath.addRect(shadowRect)
            case .left:
                let shadowRect = CGRect(x: -shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
                shadowPath.addRect(shadowRect)
            case .right:
                let shadowRect = CGRect(x: bounds.size.width - shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
                shadowPath.addRect(shadowRect)
            }
        }
        self.shadowPath = shadowPath
    }
}

