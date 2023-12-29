//
//  HMReusable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/24.
//

import UIKit

/// 重用reuseIdentifier协议
public protocol HMReusable: AnyObject {
    
    /// reuseIdentifier
    static var reuseIdentifier: String { get }
}

/// 默认实现
public extension HMReusable {
    
    /// reuseIdentifier xib中需要设置reuseIdentifier为类名
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: HMReusable {}
extension UITableViewHeaderFooterView: HMReusable {}
extension UICollectionView: HMReusable {}
extension UICollectionReusableView: HMReusable {}
