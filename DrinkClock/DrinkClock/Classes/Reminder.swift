//
//  Reminder.swift
//  DrinkClock
//
//  Created by wyz on 16/4/20.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

enum ReminderRepeatMode: String {
    case OneDay = "每天"
    case None = "关闭"
}

class Reminder: NSObject {
    
    var uuid:String = NSUUID().UUIDString

    var time:String = ""
    
    var remind:Bool = true
    
    var repeatMode:String = ReminderRepeatMode.OneDay.rawValue
    
    var sound:RemindSound = RemindSound()
    
    var tipString:String = "喝水时间到了"
    
    var isDone:Bool = false
    
    let properties = ["uuid","time","remind","repeatMode","sound","tipString","isDone"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    override init() {
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(time, forKey: "time")
        aCoder.encodeObject(remind, forKey: "remind")
        aCoder.encodeObject(repeatMode, forKey: "repeatMode")
        aCoder.encodeObject(sound, forKey: "sound")
        aCoder.encodeObject(tipString, forKey: "tipString")
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(isDone, forKey: "isDone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        time = aDecoder.decodeObjectForKey("time") as! String
        remind = aDecoder.decodeObjectForKey("remind") as! Bool
        repeatMode = aDecoder.decodeObjectForKey("repeatMode") as! String
        sound = aDecoder.decodeObjectForKey("sound") as! RemindSound
        tipString = aDecoder.decodeObjectForKey("tipString") as! String
        uuid = aDecoder.decodeObjectForKey("uuid") as! String
        isDone = aDecoder.decodeObjectForKey("isDone") as! Bool
    }
    
    
    func addReminder(reminder:Reminder) {
        
    }

}

class RemindSound: NSObject,NSCoding{
    
    var soundName:String = "梦幻水泡"
    
    var image:String = "梦幻水泡"
    
    var path:String = "1.caf"
    
    override init() {
        super.init()
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(soundName, forKey: "soundName")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(path, forKey: "path")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        soundName = aDecoder.decodeObjectForKey("soundName") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
        path = aDecoder.decodeObjectForKey("path") as! String
    }
}