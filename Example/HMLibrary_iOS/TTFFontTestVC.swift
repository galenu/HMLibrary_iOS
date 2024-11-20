//
//  TTFFontTestVC.swift
//  HMLibrary_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import HMLibrary_iOS

class TTFFontTestVC: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label1.font = .systemFont(ofSize: 17)
        
        label2.font = .font(.osBold, size: 17)
        
        label2.font = .font(.os700, size: 17)
    }

}
