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
    private var timer:NSTimer?
    private var dateformatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(visualEffectView)
        view.addSubview(bgImageView)
        view.addSubview(timeLabel)
        view.addSubview(drinkLabel)
//        visualEffectView.snp_makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        bgImageView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_centerY).offset(-20)
            make.bottom.equalTo(self.view).offset(-20)
        }
      
        timeLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-screenHeight * 0.3)
            make.centerX.equalTo(self.view)
            make.left.right.equalTo(self.view).inset(30)
        }
        drinkLabel.snp_makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp_bottom).offset(20)
            make.left.right.equalTo(self.view).inset(30)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DrinkViewController.updateData), name: dataSourceDidChangeNotification, object: nil)
        
       
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(DrinkViewController.updateTime), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateTime() {
        dateformatter.dateFormat = "yyyy-MM-dd"
//        let now = dateformatter.stringFromDate(NSDate())
//        let ealier = dateformatter.stringFromDate(NSDate().dateByAddingTimeInterval(-1.0))
//        now != ealier
        updateData()
        
    }
    
    func updateData() {
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSMutableArray
        if array != nil && array?.count != 0 {
            var nextTime:NSTimeInterval = 100000000
            for  i in 0..<array!.count {
                let r = array![i] as! Reminder
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
                drinkLabel.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Height(40))
                timeLabel.text = "下次喝水时间"
                drinkLabel.text = "\(nextReminder!.time)"
            } else {
                drinkLabel.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Height(20))
                timeLabel.text = "今天没有提醒了"
                drinkLabel.text = "明天记得按时喝水哟"
            }
            nextReminder = nil
        } else {
            drinkLabel.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Height(40))
            timeLabel.text = "当前时间"
            dateformatter.dateFormat = "a hh:mm"
            dateformatter.locale = NSLocale(localeIdentifier: "zh_CN")
            drinkLabel.text = dateformatter.stringFromDate(NSDate())
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var drinkLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Height(40))
        label.textColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Height(20))
        label.textColor = UIColor.greenColor()
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var visualEffectView: UIView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.alpha = 1.0
        visualEffectView.layer.cornerRadius = 5
        visualEffectView.layer.masksToBounds = true
        visualEffectView.userInteractionEnabled = false
        return visualEffectView
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = UIImage(named: "lovewater.jpg")
        imageView.alpha = 1.0
        return imageView
    }()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        timer?.invalidate()
        timer = nil
    }
}
