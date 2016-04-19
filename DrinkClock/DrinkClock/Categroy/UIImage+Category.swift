//
//  UIImage+Category.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithCaptureOfView(view:UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.mainScreen().scale)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        view.layer.renderInContext(ctx!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithColorAndFrame(color:UIColor,frame:CGRect) -> UIImage {
    
        UIGraphicsBeginImageContext(frame.size)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        
        CGContextFillRect(ctx, frame)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithColor(color:UIColor) -> UIImage {
        return UIImage.imageWithColorAndFrame(color, frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}