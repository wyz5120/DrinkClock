//
//  TitleSwitchView.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class TitleSwitchView: UIView {
    
    var buttonClickAction: ((buttonTag:NSInteger) -> Void)?
    
    private var selectButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blackColor()
        
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        addSubview(indicatorView)
        addSubview(leftButton)
        addSubview(rightButton)
        
        indicatorView.snp_makeConstraints { (make) in
            make.edges.equalTo(leftButton).inset(4)
        }
        
        leftButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(rightButton.snp_left)
            make.width.equalTo(rightButton)
        }
        
        rightButton.snp_makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(leftButton.snp_right)
            make.width.equalTo(leftButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("全部", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "GloberSemiBold", size: 15)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Disabled)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(TitleSwitchView.buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.selectButton = button
        button.enabled = false
        button.tag = 101
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("提醒", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "GloberSemiBold", size: 15)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Disabled)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: #selector(TitleSwitchView.buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = 102
        return button
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    func buttonAction(button:UIButton) {
    
       
        button.enabled = false
        
       indicatorView.snp_remakeConstraints { (make) in
        make.edges.equalTo(button).inset(4)
        }
        
        UIView.animateWithDuration(0.3, animations: { 
            self.layoutIfNeeded()
            }) { (_) in
                self.selectButton?.enabled = true
                self.selectButton = button
        }
        
        if buttonClickAction != nil {
            buttonClickAction!(buttonTag: button.tag)
        }
    }
    
 
    
}
