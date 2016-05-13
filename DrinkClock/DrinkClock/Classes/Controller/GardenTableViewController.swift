//
//  GardenTableViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/26.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class GardenTableViewController: UITableViewController {
    
    var isAnimating = true
    var isOpen = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 0.98)), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    private let kCloseCellHeight: CGFloat = 100
    private let kOpenCellHeight: CGFloat = 300
    
    private var cellHeights = [CGFloat]()
    private var dataSource:NSArray?
    private var downArray = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        navigationItem.titleView = titleLabel
        dataSource = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("garden", ofType: "plist")!)
        createCellHeightsArray()
        tableView.rowHeight = 100
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func createCellHeightsArray() {
        for _ in 0...dataSource!.count {
            cellHeights.append(kCloseCellHeight)
            downArray.append(false)
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: 20)
        label.textColor = UIColor.whiteColor()
        label.text = "补水果蔬"
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        return label
    }()

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GardenCell") as! GardenCell
        cell.foreTitleLabel.text = dataSource![indexPath.row]["title"] as? String
        cell.contentLabel.text = dataSource![indexPath.row]["detail"] as? String
        let imageName = (dataSource![indexPath.row]["image"] as? String)! + ".jpg"
        cell.foreImageView.image = UIImage(named: imageName)
        cell.titleDown = downArray[indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !isAnimating {
            return
        }
        cell.alpha = 0.0
        let tranformScale = CGAffineTransformMakeScale(1.0, 1.0)
        let tranformTranslate = CGAffineTransformMakeTranslation(0,100 * (CGFloat(indexPath.row) + 1))
        cell.transform = CGAffineTransformConcat(tranformScale, tranformTranslate)
        tableView .bringSubviewToFront(cell)
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 4, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            cell.transform = CGAffineTransformIdentity
            cell.alpha = 1.0
            }, completion: nil)

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        isAnimating = false
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GardenCell
        
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = cell.cellHeight()
            downArray[indexPath.row] = true
            cell.titleDown = true
            
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            downArray[indexPath.row] = false
            cell.titleDown = false
        }
        
//        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIViewAnimationOptions.CurveLinear, animations: {
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
        
    }


    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isAnimating = false
    }
}
