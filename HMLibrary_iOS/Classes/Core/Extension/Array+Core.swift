//
//  Array+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension Array {
    
    /// 防止数组越界
    public func safeValue(_ index: Int) -> Element? {
        return self[index, true]
    }
    
    /// 防止数组越界
    public subscript(index: Int, safe: Bool) -> Element? {
        if safe {
            if self.count > index && index >= 0 {
                return self[index]
            } else {
                return nil
            }
        } else {
            return self[index]
        }
    }
    
    /// 去重
    public func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
