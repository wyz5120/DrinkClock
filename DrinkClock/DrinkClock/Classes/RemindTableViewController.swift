//
//  RemindTableViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let remindCellIdentifier = "remindCellIdentifier"
class RemindTableViewController: UIViewController {
    
    var dataSource:NSMutableArray?
    var isAnimating = false
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.clearColor()
        refresh()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RemindTableViewController.refresh), name: didAddReminderNotification, object: nil)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
