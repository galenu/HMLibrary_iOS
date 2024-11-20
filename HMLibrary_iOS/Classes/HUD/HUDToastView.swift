//
//  HUDToastView.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// 自定义提示视图
public class HUDToastView: UIView {
    
    /// 提示label
    public lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    public init(text: String) {
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .init(white: 0, alpha: 0.6)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        textLabel.text = text
        self.addSubview(textLabel)
        textLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 100 - 20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

