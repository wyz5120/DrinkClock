//
//  Constant.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

// 屏幕宽度
let screenHeight = UIScreen.mainScreen().bounds.height
// 屏幕高度
let screenWidth = UIScreen.mainScreen().bounds.width
// NSUserDefault
let userDefault = NSUserDefaults.standardUserDefaults()
// 通知中心
let notice = NSNotificationCenter.defaultCenter()

func scaleFromIphone5Width(value: CGFloat) -> CGFloat {
    return value * (screenWidth / 320)
}

func scaleFromIphone5Height(value: CGFloat) -> CGFloat {
    return value * (screenHeight / 568)
}