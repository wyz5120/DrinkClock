//
//  NotificationManager.swift
//  DrinkClock
//
//  Created by wyz on 16/4/24.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class NotificationManager: NSObject {
    
    
    class func registerLoacalNotification() {
        if UIApplication.sharedApplication().currentUserNotificationSettings()?.types != UIUserNotificationType.None {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            addLoacalNotification()
        } else {
            
            let willDrinkAction = UIMutableUserNotificationAction()
            willDrinkAction.identifier = "willDrink"
            willDrinkAction.title = "好的,马上喝"
            willDrinkAction.activationMode = UIUserNotificationActivationMode.Background
            willDrinkAction.destructive = false
            willDrinkAction.authenticationRequired = false
            
            let didDrinkAction = UIMutableUserNotificationAction()
            didDrinkAction.identifier = "didDrink"
            didDrinkAction.title = "已经喝过了"
            didDrinkAction.activationMode = UIUserNotificationActivationMode.Background
            didDrinkAction.destructive = false
            didDrinkAction.authenticationRequired = false
            
            let actionArray = NSArray(objects: willDrinkAction,didDrinkAction)
            
            let drinkReminderCategory = UIMutableUserNotificationCategory()
            drinkReminderCategory.identifier = "drinkReminderCategory"
            drinkReminderCategory.setActions(actionArray as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
            drinkReminderCategory.setActions(actionArray as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
            let categories = NSSet(objects: drinkReminderCategory)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert,UIUserNotificationType.Badge,UIUserNotificationType.Sound], categories: categories as? Set<UIUserNotificationCategory>))
        }
    }

   class func addLoacalNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSMutableArray {
            for r in array {
                let reminder = r as! Reminder
                addNotifationWithReminder(reminder)
            }
        } else {
            return
        }
    }
    
   class func addNotifationWithReminder(reminder:Reminder) {
    
        if reminder.remind == false {
            return
        }
            
        let notification = UILocalNotification()
        
        let dateString = reminder.time
        
        let dateformatter = NSDateFormatter()
    
        dateformatter.locale = NSLocale(localeIdentifier: "zh_CN")
        
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let headerString = dateformatter.stringFromDate(NSDate())
        
        dateformatter.dateFormat = "yyyy-MM-dd" + "a hh:mm"
        
        let date = dateformatter.dateFromString(headerString + dateString)
   
        notification.fireDate = date
    
        if let repeatString = ReminderRepeatMode(rawValue: reminder.repeatMode) {
            switch repeatString {
            case .None:
                notification.repeatInterval = NSCalendarUnit.Era
            case .OneDay:
                notification.repeatInterval = NSCalendarUnit.Day
            }
        }

        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatCalendar = NSCalendar.currentCalendar()
        
        notification.alertBody = reminder.tipString
        notification.alertAction = "开始喝水"
        notification.applicationIconBadgeNumber = 1
        notification.soundName = reminder.sound.path
        notification.category = "drinkReminderCategory"
    
        notification.userInfo = ["notificationKey":reminder.uuid]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func cancelNotifationWithReminder(reminder:Reminder) {
        
        let notiArray = UIApplication.sharedApplication().scheduledLocalNotifications
        let count = notiArray?.count
        if count > 0 {
            for i in 0..<count! {
                let notification = notiArray![i]
                let userInfo = notification.userInfo;
                let notificationKey = userInfo!["notificationKey"] as! String
                
                if notificationKey == reminder.uuid {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
        }
    }
    
}
