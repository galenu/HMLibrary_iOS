//
//  HUDLoadingView.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// 自定义加载视图
public class HUDLoadingView: UIView {
    
    /// loading动画
    public lazy var imageView: UIImageView = {
        let view =  UIImageView()
        return view
    }()
    
    /// 提示label
    public lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    /// loading帧动画图片
    public var loadingImages = [UIImage]()
    
    public init(text: String = "", imageWidth: CGFloat = 100,  maxWidth: CGFloat = 150) {
                
        super.init(frame: CGRect.zero)
        
        if let hudBundle = self.getBundle() {
            for index in 1 ... 50 {
                let num = String(format: "%.2d", index)
                let name = "loading_\(num)"
                if let image = UIImage(named: name, in: hudBundle, compatibleWith: nil) {
                    loadingImages.append(image)
                }
            }
        }
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.addSubview(imageView)
        
        if !text.isEmpty {
            
            imageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageWidth)
            }
            
            let font = textLabel.font ?? .systemFont(ofSize: 14)
            let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let textSize = text.boundingRect(with: size,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font],
                                             context: nil).size
            
            // 文字宽度
            let textWidth = textSize.width + 40
            // 最小宽度
            let minWidth = CGFloat.minimum(textWidth, maxWidth)
            let width = CGFloat.maximum(minWidth, imageWidth + 20)
            
            textLabel.text = text
            self.addSubview(textLabel)
            textLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.width.equalTo(width)
                
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            imageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageWidth)
                
                make.bottom.equalToSuperview().offset(-10)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBundle() -> Bundle? {
        guard let path = Bundle(for: HUD.self).path(forResource: "HMLibrary_iOS.bundle", ofType: nil) else { return nil }
        let hudBundle = Bundle(path: path)
        return hudBundle
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // view被移除时
        if newSuperview == nil {
            imageView.stopAnimating()
        } else {
            // loading图片
            if !loadingImages.isEmpty {
                imageView.animationImages = loadingImages
                imageView.animationDuration = Double(loadingImages.count) * 0.05
                imageView.animationRepeatCount = 0
                imageView.startAnimating()
            }
        }
    }
}
