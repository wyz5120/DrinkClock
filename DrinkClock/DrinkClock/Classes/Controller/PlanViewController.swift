//
//  PlanViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/5/3.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit
import JazzHands

class PlanViewController: IFTTTAnimatedPagingScrollViewController {
    
    private var imageDict:NSMutableDictionary = ["image0":"1.png","image1":"2.png","image2":"3.png","image3":"4.png","image4":"5.png","image5":"6.png","image6":"7.png","image7":"8.png"]
    private var titleDict:NSMutableDictionary = ["image0":"8.png","image1":"7.png","image2":"6.png","image3":"5.png","image4":"4.png","image5":"3.png","image6":"2.png","image7":"1.png"]
    
    private let pageCount = 8
    
    let dataSource = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("drinkInfo", ofType: "plist")!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        configureViews()
        configureAnimations()
        scrollViewDidScroll(scrollView)
        view.backgroundColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        navigationItem.titleView = titleLabel
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: 20)
        label.textColor = UIColor.whiteColor()
        label.text = "喝水时间"
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        return label
    }()

    
    override func numberOfPages() -> UInt {
        return UInt(pageCount)
    }
    
    
    private func imageKeyForIndex(index:Int) -> NSString {
        return "image" + "\(index)"
    }
   
    private func viewKeyForIndex(index:Int) -> NSString {
        return "view" + "\(index)"
    }

    private func configureViews() {
        
        configurePageControlAndButton()
        
   
 
        for i in 0 ..< pageCount {
            let imageKey = imageKeyForIndex(i)
            let viewKey = viewKeyForIndex(i)
            let imageName = imageDict.objectForKey(imageKey) as! String
            let titleName = titleDict.objectForKey(imageKey) as! String
            let dict = self.dataSource[i] as! NSDictionary
            
            let iconImage = UIImage(named: imageName)
            let titleImage = UIImage(named: titleName)
            if iconImage != nil {
                let iconView = UIImageView(image: UIImage(named: (dict.valueForKey("image") as! String)))
                iconView.clipsToBounds = true
                iconView.layer.cornerRadius = 10
                iconView.layer.masksToBounds = true
                contentView.addSubview(iconView)
                imageDict.setObject(iconView, forKey: viewKey as String)
            }
            if titleImage != nil {
                let titleView = planView()
                titleView.title = (dict.valueForKey("time") as! String)
                titleView.tip = (dict.valueForKey("tip") as! String)
                contentView.addSubview(titleView)
                titleDict.setObject(titleView, forKey: viewKey as String)
                
            }
        }
    }
    
    private func configurePageControlAndButton() {
        
        view.addSubview(pageControl)
        view.addSubview(addButton)
        pageControl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(addButton.snp_top).offset(-scaleFromIphone5Height(20))
            
        }
        
        addButton.snp_makeConstraints { (make) in
            make.centerX.equalTo((self.view))
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(screenWidth * 0.5)
            make.height.equalTo(44)
        }
    }
    
    
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.pageCount
        pageControl.userInteractionEnabled = false
        pageControl.sizeToFit()
        pageControl.currentPage = 0
        return pageControl
    }()
    
    private lazy var addButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0), forState: UIControlState.Normal)
        button.setTitle("添加到提醒", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 22
        button.sizeToFit()
        button.addTarget(self, action: #selector(PlanViewController.addPlanAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    func addPlanAction() {
        let existed = NSFileManager.defaultManager().fileExistsAtPath(path)
        var array = NSMutableArray()
        if existed {
            array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
        loop: for  i in 0..<pageCount {
            let dict = self.dataSource[i] as! NSDictionary
            let r = Reminder()
            r.time = (dict.valueForKey("time") as! String)
            r.uuid = "\(i)"
            r.remind = true
            r.repeatMode = ReminderRepeatMode.OneDay.rawValue
            r.sound = RemindSound()
            r.isDone = false
            r.tipString = (dict.valueForKey("tip") as! String)
            for re in array {
                if re.uuid == r.uuid {
                    continue loop
                }
            }
            array.addObject(r)
        }
        
        NSKeyedArchiver.archiveRootObject(array, toFile: path)
        NSNotificationCenter.defaultCenter().postNotificationName(didAddReminderNotification, object: nil)
        NotificationManager.addLoacalNotification()
        
        let alert = UIAlertController(title: "成功添加到提醒", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func configureAnimations() {
        
        for i in 0 ..< pageCount {
            let viewKey = viewKeyForIndex(i)
            let iconView = imageDict.objectForKey(viewKey) as! UIView
            let titleView = titleDict.objectForKey(viewKey) as! UIView
            
            
            keepView(iconView, onPage: CGFloat(i))
            if i == 0 {
                keepView(titleView, onPage: CGFloat(i))
            } else {
                keepView(titleView, onPages: [i+1,i,i-1], atTimes: [i-1,i,i+1])
            }
         
            iconView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.view).offset(scaleFromIphone5Height(-100))
                make.width.equalTo(150)
                make.height.equalTo(200)
            })
            titleView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.view).offset(scaleFromIphone5Height(75))
                make.width.equalTo(screenWidth * 0.8)
                make.height.equalTo(120)
            })
            
            let iconAlphaAnimation = IFTTTAlphaAnimation(view: iconView)
            iconAlphaAnimation.addKeyframeForTime(CGFloat(i) - 0.5, alpha: 0.0)
            iconAlphaAnimation.addKeyframeForTime(CGFloat(i), alpha: 1.0)
            iconAlphaAnimation.addKeyframeForTime(CGFloat(i) + 0.5, alpha: 0.0)
            animator.addAnimation(iconAlphaAnimation)
          
            let titleAlphaAnimation = IFTTTAlphaAnimation(view: titleView)
            titleAlphaAnimation.addKeyframeForTime(CGFloat(i) - 0.5, alpha: 0.0)
            titleAlphaAnimation.addKeyframeForTime(CGFloat(i), alpha: 1.0)
            titleAlphaAnimation.addKeyframeForTime(CGFloat(i) + 0.5, alpha: 0.0)
            animator.addAnimation(titleAlphaAnimation)
            
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        animateCurrentFrame()
        
        let page = Int(self.pageOffset + 0.5)
        pageControl.currentPage = page
    }
}


private class planView:UIView {
    
    var title:String? {
        didSet{
            timeLabel.text = title
        }
    }
    
    var tip:String? {
        didSet{
            tipLabel.text = tip
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(timeLabel)
        addSubview(tipLabel)
        timeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.left.right.equalTo(self)
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(timeLabel.snp_bottom).offset(10)
            make.left.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greenColor()
        label.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Width(25))
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cyanColor()
        label.font = UIFont(name: "GloberSemiBold", size: scaleFromIphone5Width(14))
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
}
