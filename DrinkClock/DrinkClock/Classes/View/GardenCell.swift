//
//  GardenCell.swift
//  DrinkClock
//
//  Created by wyz on 16/4/26.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class GardenCell: UITableViewCell {

    @IBOutlet weak var foreImageView: UIImageView!
    @IBOutlet weak var foreTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var titleDown = false {
        didSet {
            if titleDown {
                startAnimation(true)
            } else {
                startAnimation(false)
            }
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        foreTitleLabel.layer.cornerRadius = 10
        foreTitleLabel.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    
    func cellHeight() -> CGFloat {
        let detailText = contentLabel.text! as NSString
        let height = detailText.boundingRectWithSize(CGSize(width: screenWidth - 30,height:1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont(name: "GloberSemiBold", size: 15)!], context: nil).size.height
        return height + 144
    }
    
    func startAnimation(down:Bool) {
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            if down {
                self.foreTitleLabel.transform = CGAffineTransformMakeTranslation(0, 36)
            } else {
                self.foreTitleLabel.transform = CGAffineTransformIdentity
            }
            }, completion: nil)
    }

}
