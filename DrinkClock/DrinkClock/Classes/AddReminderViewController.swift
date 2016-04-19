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

class AddReminderViewController: UIViewController {

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
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(360)
        }
        
        
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func stringFromDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.stringFromDate(date)
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
            datePickerView.doneButtonClickAction =  {(date) -> Void in
                cell.inputTextField.text = self.stringFromDate(date)
                cell.inputTextField.resignFirstResponder()
            }

            cell.inputTextField.inputView = datePickerView
            cell.inputTextField.iconImage = UIImage(named: "time")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellSwitchIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "reminderGrey")
            cell.tipLabel.text = "提醒"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "repeatGrey")
            cell.tipLabel.text = "重复"
            cell.selectionLabel.text = "每天"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellDetailIdentifier) as! AddDetailCell
            cell.iconView.image = UIImage(named: "completedBtn")
            cell.tipLabel.text = "声音"
            cell.selectionLabel.text = "流水"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(addCellInputIdentifier) as! AddInputCell
            cell.inputTextField.placeholder = "提示内容"
            cell.inputTextField.iconImage = UIImage(named: "reminderGrey")
            cell.inputTextField.text = "喝水时间到了"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    


}
