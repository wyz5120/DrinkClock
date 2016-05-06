//
//  DrinkViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/5/5.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    private var nextReminder:Reminder?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(visualEffectView)
        view.addSubview(drinkLabel)
        visualEffectView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        drinkLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.left.right.equalTo(self.view).inset(30)
        }
        
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSMutableArray {
            let dateformatter = NSDateFormatter()
            var nextTime:NSTimeInterval = 100000000
            for  i in 0..<array.count {
                let r = array[i] as! Reminder
                if r.remind {
                    let dateString = r.time
                    dateformatter.locale = NSLocale(localeIdentifier: "zh_CN")
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let headerString = dateformatter.stringFromDate(NSDate())
                    dateformatter.dateFormat = "yyyy-MM-dd" + "a hh:mm"
                    let date = dateformatter.dateFromString(headerString + dateString)
                    
                    let timeInterval = NSDate().timeIntervalSinceDate(date!)
                    
                    if timeInterval < 0 {
                        if -timeInterval < nextTime {
                            nextTime = -timeInterval
                            nextReminder = r
                        }
                    }
                }
            }
            
            
            if nextReminder != nil {
                let dateComponentsFormatter = NSDateComponentsFormatter()
                let dateSince = dateComponentsFormatter.stringFromTimeInterval(nextTime)!
                var h:String?
                var m:String?
                if dateSince.characters.count == 5 {
                    m = dateSince[0...2]
                }
                else if dateSince.characters.count == 7 {
                    h = dateSince[0...0]
                    m = dateSince[2...3]
                }
                else if dateSince.characters.count == 8{
                    h = dateSince[0...1]
                    m = dateSince[3...4]
                }
                print(dateSince)
                print(h)
                print(m)
                drinkLabel.text = "距离下次喝水时间\(nextReminder!.time)还有 \(dateSince)"
            } else {
                drinkLabel.text = "还没有添加提醒呢"
            }
        }
     
        
     
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var drinkLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: 20)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.alpha = 0.5
        visualEffectView.layer.cornerRadius = 5
        visualEffectView.layer.masksToBounds = true
        visualEffectView.userInteractionEnabled = false
        return visualEffectView
    }()
}
