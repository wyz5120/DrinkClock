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
//导航栏状态栏高度
let topHeight:CGFloat = 64
//状态栏高度
let statusBarHeight:CGFloat = 20
//导航栏高度
let NavigationBarHeight:CGFloat = 44
// 通知中心
let notice = NSNotificationCenter.defaultCenter()

let keyWindow = UIApplication.sharedApplication().keyWindow

func scaleFromIphone5Width(value: CGFloat) -> CGFloat {
    return value * (screenWidth / 320)
}

func scaleFromIphone5Height(value: CGFloat) -> CGFloat {
    return value * (screenHeight / 568)
}

func device_Is_iPhone5() -> Bool {
    if UIScreen.instancesRespondToSelector(Selector("currentMode")) {
        return CGSizeEqualToSize(CGSize(width: 640,height: 1136), UIScreen.mainScreen().currentMode!.size)
    } else {
        return false
    }
}

func device_Is_iPhone6() -> Bool {
    if UIScreen.instancesRespondToSelector(Selector("currentMode")) {
        return CGSizeEqualToSize(CGSize(width: 750,height: 1334), UIScreen.mainScreen().currentMode!.size)
    } else {
        return false
    }
}

func device_Is_iPhone6Plus() -> Bool {
    if UIScreen.instancesRespondToSelector(Selector("currentMode")) {
        return CGSizeEqualToSize(CGSize(width: 1242,height: 2208), UIScreen.mainScreen().currentMode!.size)
    } else {
        return false
    }
}


func randomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue:CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[startIndex..<endIndex]
        }
    }
}