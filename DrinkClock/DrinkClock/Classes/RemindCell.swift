//
//  RemindCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let borderColor = UIColor(red: 238/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0).CGColor
class RemindCell: UITableViewCell {
    
    var reminder:Reminder? {
        didSet{
            timeLabel.text = reminder!.time
            remindButton.selected = reminder!.remind
            doneButton.selected = reminder!.isDone
        }
    }
    
    var remindButtonClickClosure:(()->Void)?
    var doneButtonClickClosure:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(visualEffectView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(remindButton)
        contentView.addSubview(doneButton)
      
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.centerY.equalTo(self.contentView)
        }
        
//        remindButton.snp_makeConstraints { (make) in
//            make.right.equalTo(doneButton.snp_left)
//            make.centerY.equalTo(self.contentView)
//            make.width.height.equalTo(50)
//        }
        
        remindButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(50)
        }
        
        visualEffectView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greenColor()
        label.font = UIFont(name: "GloberxBold", size: 18)
        label.userInteractionEnabled = false
        return label
    }()

    private lazy var remindButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "reminderGrey"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "reminderLarge"), forState: UIControlState.Selected)
        button.addTarget(self, action: #selector(RemindCell.remindButtonClickAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "completeBtn"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "completedBtn"), forState: UIControlState.Selected)
        button.addTarget(self, action: #selector(RemindCell.doneButtonClickAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.alpha = 1.0
        visualEffectView.layer.cornerRadius = 5
        visualEffectView.layer.masksToBounds = true
        visualEffectView.userInteractionEnabled = false
        return visualEffectView
    }()
    
    func remindButtonClickAction() {
        if remindButtonClickClosure != nil {
            remindButtonClickClosure!()
        }
    }
    
    func doneButtonClickAction() {
        if doneButtonClickClosure != nil {
            doneButtonClickClosure!()
        }
    }
}
