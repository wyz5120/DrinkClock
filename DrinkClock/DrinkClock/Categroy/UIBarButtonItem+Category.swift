//
//  UIBarButtonItem+Category.swift
//  SwiftWeibo
//
//  Created by wyz on 16/3/4.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func item(imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName), forState: UIControlState.Highlighted)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }
}