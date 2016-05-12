//
//  RemindTableViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let remindCellIdentifier = "remindCellIdentifier"
let dataSourceDidChangeNotification = "dataSourceDidChangeNotification"
class RemindTableViewController: UIViewController {
    
    var dataSource:NSMutableArray?
    var isAnimating = false
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        view.addSubview(coverView)
        tableView.backgroundColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RemindTableViewController.refresh), name: didAddReminderNotification, object: nil)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        coverView.hidden = true
        
        refresh()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(RemindCell.self, forCellReuseIdentifier: remindCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var coverView:UIView = {
        let view = CoverView()
        view.addReminderColoure = {[weak self]() -> Void in
            self!.addReminderPlan()
        }
        return view
    }()
    
    func addReminderPlan() {
        let plan = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("drinkInfo", ofType: "plist")!)!
        let existed = NSFileManager.defaultManager().fileExistsAtPath(path)
        var array = NSMutableArray()
        if existed {
            array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
        loop: for  i in 0..<8 {
            let dict = plan[i] as! NSDictionary
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
  
    func refresh() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dataSource = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSMutableArray
        if dataSource?.count >= 2 {
            dataSource!.sortUsingComparator({ (r1, r2) -> NSComparisonResult in
                let reminder1 = r1 as! Reminder
                let reminder2 = r2 as! Reminder
                let d1 = dateFormatter.dateFromString(reminder1.time)
                let d2 = dateFormatter.dateFromString(reminder2.time)
                return d1!.compare(d2!)
            })
        }
        
        if dataSource == nil {
            coverView.hidden = false
        } else {
           coverView.hidden = dataSource?.count != 0
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(dataSourceDidChangeNotification, object: nil)
        tableView.reloadData()
    }
    
    func updateData(reminder:Reminder) {
       
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        for  i in 0..<array.count {
            let r = array[i] as! Reminder
            if r.uuid == reminder.uuid {
                array.replaceObjectAtIndex(i, withObject: reminder)
                break
            }
        }
        NSKeyedArchiver.archiveRootObject(array, toFile: path)
        self.refresh()
    }

}

extension RemindTableViewController:UITableViewDataSource,UITableViewDelegate {
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if let list = dataSource {
            rows = list.count
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(remindCellIdentifier) as! RemindCell
        let reminder = dataSource![indexPath.row] as! Reminder
        cell.reminder = reminder
        cell.remindButtonClickClosure = {[weak self]()->Void in
            reminder.remind = !reminder.remind
           self!.updateData(reminder)
            self!.isAnimating = false
            if reminder.remind {
                NotificationManager.addNotifationWithReminder(reminder)
            } else {
                NotificationManager.cancelNotifationWithReminder(reminder)
            }
        }
        cell.doneButtonClickClosure = {[weak self]()->Void in
            reminder.isDone = !reminder.isDone
            self!.updateData(reminder)
            self!.isAnimating = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addReminderVc = AddReminderViewController()
        addReminderVc.reminder = dataSource![indexPath.row] as? Reminder
        let navigationVc = NavigationController(rootViewController: addReminderVc)
        presentViewController(navigationVc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isAnimating {
            return
        }
        let tranformScale = CGAffineTransformMakeScale(0.6, 0.8)
        let tranformTranslate = CGAffineTransformMakeTranslation(0.6,0.8)
        cell.transform = CGAffineTransformConcat(tranformScale, tranformTranslate)
        tableView .bringSubviewToFront(cell)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            cell.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isAnimating = true
    }
 
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isAnimating = false
    }
    
}

 class CoverView:UIView {
    
    
    var addReminderColoure:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(visualEffectView)
        addSubview(textLabel)
        addSubview(addButton)
        visualEffectView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        textLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp_centerY).offset(-20)
        }
        
        addButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp_centerY).offset(10)
            make.width.equalTo(screenWidth * 0.5)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cyanColor()
        label.font = UIFont(name: "GloberSemiBold", size: scaleFromIphone5Width(17))
        label.text = "还没添加提醒呢"
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    private lazy var addButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0), forState: UIControlState.Normal)
        button.setTitle("添加推荐时间", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0).CGColor
        button.sizeToFit()
        button.addTarget(self, action:#selector(CoverView.addPlanAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.alpha = 1.0
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.layer.masksToBounds = true
        visualEffectView.userInteractionEnabled = false
        return visualEffectView
    }()
    
    func addPlanAction() {
        if addReminderColoure != nil {
            addReminderColoure!()
        }
    }
}
