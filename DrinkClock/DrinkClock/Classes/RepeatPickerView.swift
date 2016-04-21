//
//  repeatPickerView.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let HInset:CGFloat = 30
private let VInset:CGFloat = screenHeight * 0.2

private let animationDuration = 0.5
private let damp:CGFloat = 0.8
private let velocity:CGFloat = 2

private let repeatCellIdentifier = "repeatCellIdentifier"

private let repeatLabelColor = UIColor(red: 27/255.0, green: 42/255.0, blue: 71/255.0, alpha: 1.0)

class RepeatPickerView: UIView {
    
    var didSelectRowClosure:((text:String) -> Void)?
    
    private let dataSource = ["每一小时","每二小时","每三小时","每天","关闭"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        self.snp_makeConstraints { (make) in
            make.edges.equalTo(self.superview!)
        }
        
        addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: VInset + screenHeight , left:HInset, bottom: VInset - screenHeight, right: HInset))
        }
        
        hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(repeatCell.self, forCellReuseIdentifier: repeatCellIdentifier)
        tableView.rowHeight = (screenHeight * 0.6 - 40) / 5
        tableView.scrollEnabled = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        return tableView
    }()
    
     func show() {
        tableView.layoutIfNeeded()
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        hidden = false
        tableView.snp_remakeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: VInset , left: HInset, bottom: VInset, right: HInset))
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: damp, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.tableView.layoutIfNeeded()
            }) { (_) in
                
        }
    }
    
    
    func hide() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        tableView.snp_remakeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: VInset + screenHeight , left: HInset, bottom: VInset - screenHeight, right: HInset))
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: damp, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.tableView.layoutIfNeeded()
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (_) in
            self.hidden = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hide()
    }
    
    deinit{
        print(NSStringFromClass(self.classForCoder) + "释放")
    }
}

extension RepeatPickerView:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(repeatCellIdentifier) as! repeatCell
        cell.repeatLabel.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if didSelectRowClosure != nil {
            didSelectRowClosure!(text:dataSource[indexPath.row])
        }
        
        hide()
    }
}

class repeatCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.addSubview(repeatLabel)
        repeatLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var repeatLabel:UILabel = {
        let label = UILabel()
        label.textColor = repeatLabelColor
        label.font = UIFont(name: "GloberSemiBold", size: 18)
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
}
