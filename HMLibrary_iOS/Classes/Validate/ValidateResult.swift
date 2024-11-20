//
//  ValidatorResult.swift
//  JCXX
//
//  Created by gavin on 2023/7/26.
//

import UIKit

/// 校验结果
public enum ValidateResult: Equatable {
    /// 无校验
    case none
    /// 验证通过
    case ok
    /// 验证失败
    case failed(msg: String)
}

extension ValidateResult {
    
    /// 校验为空
    public var none: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    /// 校验是否通过
    public var ok: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
    /// 校验不通过
    public var failed: Bool {
        switch self {
        case .failed(_):
            return true
        default:
            return false
        }
    }

    /// 错误提示
    public var msg: String {
        switch self {
        case .none:
            return ""
        case .ok:
            return ""
        case let .failed(message):
            return message
        }
    }
}
