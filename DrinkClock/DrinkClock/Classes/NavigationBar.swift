//
//  NavigationBar.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
     super.init(frame: frame)
        setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        shadowImage = UIImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        for button in subviews {
            if !button.isKindOfClass(UIButton) {
                continue
            }
            if button.frame.origin.x < frame.size.width * 0.5 {
                button.frame.origin.x = 5
            } else {
                button.frame.origin.x = frame.size.width - 5 - button.frame.size.width
            }
        }
    }

}
