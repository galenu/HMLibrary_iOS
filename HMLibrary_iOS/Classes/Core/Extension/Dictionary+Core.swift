//
//  Dictionary+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension Dictionary {
    
    /// 将字典转成json字符串
    public func toString() -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return ""
        }
        guard let jsonStr = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonStr
    }
}

