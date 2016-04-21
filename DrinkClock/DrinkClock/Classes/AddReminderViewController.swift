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
    private var remindSwitch:UISwitch?
    private var repeatLabel:UILabel?
    private var soundLabel:UILabel?
    private var messageTextField:UITextField?
    
    private var reminder:Reminder = Reminder()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("cancelBtn", target: self, action: #selector(AddReminderViewController.dismissAction))
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "新提醒"
        titleLabel.font = UIFont(name: "GloberSemiBold", size: 20)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

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
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        initializeReminder()
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

     func dismissAction() {
        dismissViewControllerAnimated(true, completion: nil)
        repeatPickerView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func initializeReminder() {
        remindSwitch?.on = reminder.remind
        repeatLabel?.text = reminder.repeatMode.rawValue
        soundLabel?.text = reminder.sound.soundName
        messageTextField?.text = "喝水时间到了"
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
//        tableView.scrollEnabled = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return tableView
    }()
    
    private lazy var footerView:UIView = {
        let view = UIView()
        return view
    }()
    
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
        
        voicePickerView.willHide = {[weak self]() -> Void in
            UIView.animateWithDuration(0.5, animations: {
                self!.tableView.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private lazy var repeatPickerView:RepeatPickerView = RepeatPickerView()
    private lazy var voicePickerView:VoicePickerView = VoicePickerView()
    
    func addReminderAction() {
        
        if !timeTextField!.hasText() {
            
            let alert = UIAlertController(title: "请设置时间", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "好哒", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    deinit{
        print("销毁")
    }
}

extension AddReminderViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellInputIdentifier) as! AddInputCell
            cell.inputTextField.placeholder = "时间"
            let datePickerView = DatePickerView()
        
            datePickerView.doneButtonClickAction =  {[weak self](date) -> Void in
                cell.inputTextField.text = self!.stringFromDate(date)
                cell.inputTextField.resignFirstResponder()
                self!.reminder.time = date
            }
            timeTextField = cell.inputTextField
            cell.inputTextField.inputView = datePickerView
            cell.inputTextField.iconImage = UIImage(named: "time")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellSwitchIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "reminderGrey")
            cell.tipLabel.text = "提醒"
            cell.remindSwitchActionClosure = {[weak self](on) -> Void in
                self!.reminder.remind = on
            }
            remindSwitch = cell.remindSwitch
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "repeatGrey")
            cell.tipLabel.text = "重复"
            repeatPickerView.didSelectRowAtIndex = {[weak self](text) -> Void in
                cell.selectionLabel.text = text
                if let p = ReminderRepeatMode(rawValue: text) {
                    switch p {
                    case .None:
                        self?.reminder.repeatMode = ReminderRepeatMode.None
                    case .OneDay:
                        self?.reminder.repeatMode = ReminderRepeatMode.OneDay
                    case .OneHour:
                        self?.reminder.repeatMode = ReminderRepeatMode.OneHour
                    case .TwoHours:
                        self?.reminder.repeatMode = ReminderRepeatMode.TwoHours
                    case .ThreeHours:
                        self?.reminder.repeatMode = ReminderRepeatMode.ThreeHours
                    }
                }
            }
            repeatLabel = cell.selectionLabel
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "completedBtn")
            cell.tipLabel.text = "声音"
            voicePickerView.didSelectItem = {(sound) -> Void in
                cell.selectionLabel.text = sound.soundName
            }
            soundLabel = cell.selectionLabel
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellInputIdentifier) as! AddInputCell
            cell.inputTextField.placeholder = "提示内容"
            cell.inputTextField.iconImage = UIImage(named: "reminderGrey")
            cell.inputTextField.text = "喝水时间到了"
            messageTextField = cell.inputTextField
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
