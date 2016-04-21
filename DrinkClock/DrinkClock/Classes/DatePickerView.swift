//
//  DatePickerView.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    var doneButtonClickClosure: ((date:NSDate) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 250))
        
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(datePicker)
        addSubview(doneButton)
        datePicker.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 25, left: 15, bottom: 10, right: 15))
        }
        doneButton.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Time
        return datePicker
    }()
    
    private lazy var doneButton:UIButton = {
        let button = UIButton()
        button.setTitle("完成", forState: UIControlState.Normal)
        button.titleLabel?.font  = UIFont(name: "GloberSemiBold", size: 18)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(DatePickerView.doneButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    func doneButtonAction(){
        
        if doneButtonClickClosure != nil {
            doneButtonClickClosure!(date: datePicker.date)
        }
    }
}
