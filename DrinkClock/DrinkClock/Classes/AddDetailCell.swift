//
//  AddLabelCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

let addCellDetailIdentifier = "addCellDetailIdentifier"
let addCellSwitchIdentifier = "addCellSwitchIdentifier"

private let borderColor = UIColor(red: 238/255.0, green: 244/255.0, blue: 248/255.0, alpha: 1.0).CGColor
private let tipLabelColor = UIColor(red: 27/255.0, green: 42/255.0, blue: 71/255.0, alpha: 1.0)
private let switchColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0)

class AddDetailCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(iconView)
        contentView.addSubview(tipLabel)
        contentView.addSubview(selectionLabel)
        contentView.addSubview(remindSwitch)
        
        iconView.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(45)
        })
        
        tipLabel.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(iconView.snp_right)
            make.centerY.equalTo(self.contentView)
        })
        
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
        }
        
        selectionLabel.snp_makeConstraints { (make) in
            make.left.equalTo(tipLabel.snp_right).offset(20)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-30)
        }
        
        remindSwitch.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-30)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(44)
            make.height.equalTo(30)
        }
        selectionStyle = UITableViewCellSelectionStyle.None
        
        if reuseIdentifier == addCellDetailIdentifier {
            remindSwitch.hidden = true
            selectionLabel.hidden = false
        } else {
            selectionLabel.hidden = true
            remindSwitch.hidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
     lazy var iconView = UIImageView()
    
     lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = tipLabelColor
        label.font = UIFont(name: "GloberSemiBold", size: 18)
        label.text = "提醒"
        return label
    }()
    
    lazy var selectionLabel:UILabel = {
        let label = UILabel()
        label.textColor = tipLabelColor
        label.font = UIFont(name: "GloberSemiBold", size: 18)
        label.text = "提醒"
        label.textAlignment = NSTextAlignment.Right
        return label
    }()
    
    lazy var remindSwitch:UISwitch = {
        let remindSwitch = UISwitch()
//        remindSwitch.tintColor = switchColor
        return remindSwitch
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage.imageWithColor(UIColor.whiteColor())
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = borderColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        bgImageView.layer.borderColor = selected ? switchColor.CGColor : borderColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
