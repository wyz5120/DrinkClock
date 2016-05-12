//
//  AddTextField.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let bgClolor = UIColor(red: 238/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0)

private let placeHolderColor = UIColor(red: 166/255.0, green: 172/255.0, blue: 176/255.0, alpha: 1.0)

private let borderColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0).CGColor

class AddTextField: UITextField {

    var iconImage: UIImage? {
        didSet{
            iconView.image = iconImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clearButtonMode = UITextFieldViewMode.WhileEditing
        placeholder = "时间"
        addSubview(bgImageView)
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        font = UIFont(name: "GloberSemiBold", size: 18)
        leftView = iconView
        leftViewMode = UITextFieldViewMode.Always
        
        iconView.frame.size.width = 45
        iconView.frame.size.height = 45
        
        setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        setValue(UIFont(name: "GloberSemiBold", size: 18), forKeyPath: "_placeholderLabel.font")
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage.imageWithColor(bgClolor)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var iconView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.Center
        return imageView
    }()
    
    override func becomeFirstResponder() -> Bool {
        bgImageView.layer.borderColor = borderColor
        bgImageView.layer.borderWidth = 2
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        bgImageView.layer.borderWidth = 0
        return super.resignFirstResponder()
    }
    
}
