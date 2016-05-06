//
//  TitleView.swift
//  DrinkClock
//
//  Created by wyz on 16/4/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class TitleView: UIView {

    var showing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(contentView)
        contentView.addSubview(switchView)
        contentView.addSubview(titleLabel)
        
        switchView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(36)
            make.bottom.equalTo(self).offset(-4)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(44)
            make.bottom.equalTo(switchView.snp_top).offset(-8)
        }
        
        contentView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(88)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    private lazy var switchView:TitleSwitchView = {
        let switchView = TitleSwitchView()
        switchView.frame.size.width = screenWidth * 0.5
        switchView.frame.size.height = 36
        
        return switchView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DrinkingTime"
        label.font = UIFont(name: "GloberxBold", size: 18)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    func show() {
        
        showing = !showing
        if showing {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 7, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.contentView.transform = CGAffineTransformMakeTranslation(0, 44)
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 7, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.contentView.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
       }
}