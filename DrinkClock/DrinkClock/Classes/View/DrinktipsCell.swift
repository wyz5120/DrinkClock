//
//  DrinktipsCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/26.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class DrinktipsCell: FoldingCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
        
        var fontSize:CGFloat = 14
        if device_Is_iPhone6() {
            fontSize = 14.5
        } else if device_Is_iPhone6Plus() {
            fontSize = 15.5
        }
        
        detailLabel.font = UIFont(name: "GloberSemiBold", size: fontSize)
        
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
