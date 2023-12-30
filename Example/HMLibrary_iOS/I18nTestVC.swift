//
//  I18nTestVC.swift
//  HMLibrary_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import HMLibrary_iOS

class I18nTestVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.i18n.text = "test_text".localized()
        
        button.i18n.setTitle("test_text".localized(), forState: .normal)
        
        textField.i18n.text = "test_text".localized()
        
        textView.i18n.text = "test_text".localized()
        
    }

}
