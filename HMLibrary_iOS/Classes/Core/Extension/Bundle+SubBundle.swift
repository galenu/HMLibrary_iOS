//
//  Bundle+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/24.
//

import UIKit

extension Bundle {
    
    /// 获取子Bundle
    /// - Parameter name: 子Bundle名称
    /// - Returns: 子Bundle
    public func subBundleFor(_ name: String? = nil) -> Bundle {
        if let name = name,
           let url = self.url(forResource: name, withExtension: "bundle"),
           let subBundle = Bundle(url: url) {
           return subBundle
        }
        return self
    }
}
