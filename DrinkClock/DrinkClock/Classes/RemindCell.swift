//
//  RemindCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class RemindCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(remindButton)
        contentView.addSubview(doneButton)
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20)
            make.centerY.equalTo(self.contentView)
        }
        
        remindButton.snp_makeConstraints { (make) in
            make.right.equalTo(doneButton.snp_left)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(50)
        }
        
        doneButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(50)
        }
        
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greenColor()
        label.font = UIFont(name: "GloberxBold", size: 18)
        return label
    }()

    private lazy var remindButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.yellowColor()
        button.setBackgroundImage(UIImage(named: "reminderGrey"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "reminderBlack"), forState: UIControlState.Selected)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.brownColor()
        button.setBackgroundImage(UIImage(named: "completeBtn"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "completedBtn"), forState: UIControlState.Selected)
        return button
    }()
}
