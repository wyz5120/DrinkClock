//
//  AddCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

let addCellInputIdentifier = "addCellInputIdentifier"

class AddInputCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(inputTextField)
        inputTextField.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
        }
        
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var inputTextField: AddTextField = {
        let textField = AddTextField()
        return textField
    }()
    
}
