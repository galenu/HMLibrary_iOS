//
//  LightInfoVC.swift
//  HMLibrary_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class RouteTestVC: UIViewController {
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    init(deviceId: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        textLabel.text = "Route 路由跳转"
        
        textLabel.frame = CGRect(x: 30, y: 100, width: 300, height: 40)
        self.view.addSubview(textLabel)
    }

}
