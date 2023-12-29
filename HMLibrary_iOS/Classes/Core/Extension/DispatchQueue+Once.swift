//
//  DispatchQueue+Once.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

extension DispatchQueue {
    
    /// 确保只执行一次的key值集合
    private static var _taskNameSet = Set<String>()
    
    /// 确保只执行一次任务
    /// - Parameters:
    ///   - taskName: 任务name
    ///   - block: 执行任务
    public static func once(_ taskName: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _taskNameSet.contains(taskName) {
            return
        }
        _taskNameSet.insert(taskName)
        block()
    }
}

