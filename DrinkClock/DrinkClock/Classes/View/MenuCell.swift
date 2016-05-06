//
//  MenuCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.addSubview(containerView)
        containerView.addSubview(bgView)
        bgView.addSubview(shadowView)
        contentView.addSubview(titleLabel)
        
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
        bgView.snp_makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
        shadowView.snp_makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var shadowView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: 20)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        label.shadowColor = UIColor.blackColor()
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    private func startAnimation() {
        UIView.animateWithDuration(10, animations: { 
            self.bgView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { (_) in
                UIView.animateWithDuration(10, animations: { 
                    self.bgView.transform = CGAffineTransformIdentity
                    }, completion: { (_) in
                        self.startAnimation()
                })
        }
    }

}
