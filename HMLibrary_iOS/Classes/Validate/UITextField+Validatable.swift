//
//  UITextField+Validator.swift
//  JCXX
//
//  Created by gavin on 2023/7/26.
//

import UIKit

extension UITextField: Validatable {
    
    /// 结束编辑时进行校验
    public func validateOnEditingDidEnd(_ enabled: Bool) {
        if enabled {
            addTarget(self, action: #selector(validateEditingDidEnd), for: .editingDidEnd)
        } else {
            removeTarget(self, action: #selector(validateEditingDidEnd), for: .editingDidEnd)
        }
    }
    
    /// 输入改变时进行校验
    public func validateOnEditingChanged(_ enabled: Bool) {
        if enabled {
            addTarget(self, action: #selector(validateEditingChanged), for: .editingChanged)
        } else {
            removeTarget(self, action: #selector(validateEditingChanged), for: .editingChanged)
        }
    }
    
    @objc private func validateEditingDidEnd(_ sender: UITextField) {
        self.validateFormat(text: self.text)
    }
    
    @objc private func validateEditingChanged(_ sender: UITextField) {
        self.validateFormat(text: self.text)
    }
}
