//
//  AddReminderViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

private let addReminderCellIdentifier = "addReminderCellIdentifier"
private let themeColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0)

class AddReminderViewController: UIViewController {
    
    private var timeTextField:UITextField?
    
    private var reminder:Reminder = Reminder()
    
    private var dataSource:[NSInteger:AnyObject]!
 
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        dataSource = [0:reminder.time,
                                1:reminder.remind,
                                2:reminder.repeatMode,
                                3:reminder.sound,
                                4:reminder.tipString]
        
        setupNav()
        addSubViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        navigationController?.navigationBar .setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forBarMetrics: UIBarMetrics.Default)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "释放")
    }
    
    // MARK: - 懒加载
    private lazy var tableView:TPKeyboardAvoidingTableView = {
        let tableView = TPKeyboardAvoidingTableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(AddInputCell.self, forCellReuseIdentifier: addCellInputIdentifier)
        tableView.registerClass(AddDetailCell.self, forCellReuseIdentifier: addCellDetailIdentifier)
        tableView.registerClass(AddDetailCell.self, forCellReuseIdentifier: addCellSwitchIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return tableView
    }()
    
    private lazy var footerView:UIView = UIView()
    
    private lazy var addbutton:UIButton = {
        let button = UIButton()
        button.setTitle("添加", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = themeColor
        button.titleLabel?.font = UIFont(name: "GloberSemiBold", size: 15)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(AddReminderViewController.addReminderAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var datePickerView:DatePickerView = {
        let datePickerView = DatePickerView()
        datePickerView.doneButtonClickClosure =  {[weak self](date) -> Void in
            self!.dataSource[0] = self!.stringFromDate(date)
            self!.tableView.reloadData()
            self!.view.endEditing(true)
        }
        return datePickerView
    }()
    private lazy var repeatPickerView:RepeatPickerView = {
        let repeatPickerView = RepeatPickerView()
        repeatPickerView.didSelectRowClosure = {[weak self](text) -> Void in
            self!.dataSource[2] = text
            self!.tableView.reloadData()
        }
        return repeatPickerView
    }()
    private lazy var voicePickerView:VoicePickerView = {
        let voicePickerView = VoicePickerView()
        voicePickerView.didSelectItemClosure = {[weak self](sound) -> Void in
            self!.dataSource[3] = sound
            self!.tableView.reloadData()
        }
        return voicePickerView
    }()
    
    // MARK: - 闭包

    //MARK: - 事件响应
    func addReminderAction() {
        
        reminder.time = dataSource[0] as! String
        reminder.remind = dataSource[1] as! Bool
        reminder.repeatMode = dataSource[2] as! String
        reminder.sound = dataSource[3] as! RemindSound
        reminder.tipString = dataSource[4] as! String
       
        if  reminder.time == "" || reminder.tipString == "" {
            
            let alert = UIAlertController(title: "请设置时间和提示内容", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "好哒", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
       save()
    }
    
    func dismissAction() {
        dismissViewControllerAnimated(true, completion: nil)
        repeatPickerView.removeFromSuperview()
        voicePickerView.removeFromSuperview()
    }
    
    // MARK: - 私有方法
    private func stringFromDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    private func showVoicePicker() {
        voicePickerView.show()
        
        let offsetY = (screenHeight - 424) - 170
        let translationY = offsetY <= 0 ? offsetY : 0
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.transform = CGAffineTransformMakeTranslation(0, translationY)
        })
        
        voicePickerView.willHideClosure = {[weak self]() -> Void in
            UIView.animateWithDuration(0.5, animations: {
                self!.tableView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        footerView.frame.size.height = 60
        footerView.addSubview(addbutton)
        addbutton.snp_makeConstraints { (make) in
            make.center.equalTo(footerView)
            make.width.equalTo(screenWidth * 0.7)
            make.height.equalTo(44)
        }
        tableView.tableFooterView = footerView
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("cancelBtn", target: self, action: #selector(AddReminderViewController.dismissAction))
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "新提醒"
        titleLabel.font = UIFont(name: "GloberSemiBold", size: 20)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    private func save() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingString("/reminder.plist")
        
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        array.addObject(reminder)
         NSKeyedArchiver.archiveRootObject(array, toFile: path)
    }
}

// MARK: - 数据源&代理
extension AddReminderViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellInputIdentifier) as! AddInputCell
            cell.inputTextField.placeholder = "时间"
            cell.inputTextField.inputView = datePickerView
            cell.inputTextField.iconImage = UIImage(named: "time")
            cell.inputTextField.text = dataSource[indexPath.row] as? String
            cell.textFieldClearClosure = {[weak self]() -> Void in
                self!.dataSource[indexPath.row] = ""
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellSwitchIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "reminderGrey")
            cell.tipLabel.text = "提醒"
            cell.remindSwitchChangedClosure = {[weak self](on) -> Void in
                self!.dataSource[indexPath.row] = on
            }
            cell.remindSwitch.on = dataSource[indexPath.row] as! Bool
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "repeatGrey")
            cell.tipLabel.text = "重复"
            cell.selectionLabel.text = dataSource[indexPath.row] as? String
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "completedBtn")
            cell.tipLabel.text = "声音"
            let sound = dataSource[indexPath.row] as! RemindSound
            cell.selectionLabel.text = sound.soundName
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellInputIdentifier) as! AddInputCell
            cell.inputTextField.placeholder = "提示内容"
            cell.inputTextField.iconImage = UIImage(named: "reminderGrey")
            cell.inputTextField.text = dataSource[indexPath.row] as? String
            cell.editingChangedClosure = {[weak self](text) -> Void in
                self!.dataSource[indexPath.row] = text
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         self.view.endEditing(true)
        
        if indexPath.row == 2 {
            repeatPickerView.show()
        }
        
        if indexPath.row == 3 {
            showVoicePicker()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
