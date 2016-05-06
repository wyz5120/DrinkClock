//
//  DrinkTipsTableViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/26.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class DrinktipsTableViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 0.98)), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    let kCloseCellHeight: CGFloat = 76
    let kOpenCellHeight: CGFloat = 136
    
    var cellHeights = [CGFloat]()
    var dataSource:NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        navigationItem.titleView = titleLabel
        
        dataSource = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("drinktips", ofType: "plist")!)
        
        createCellHeightsArray()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func createCellHeightsArray() {
        for _ in 0...dataSource!.count {
            cellHeights.append(kCloseCellHeight)
        }
    }

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GloberxBold", size: 20)
        label.textColor = UIColor.whiteColor()
        label.text = "喝水小贴士"
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.Center
        return label
    }()

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataSource!.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is DrinktipsCell  {
            let foldingCell = cell as! DrinktipsCell
            foldingCell.backgroundColor = UIColor.clearColor()
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell") as! DrinktipsCell
        cell.titleLabel.text = dataSource![indexPath.row]["title"] as? String
        cell.detailLabel.text = dataSource![indexPath.row]["detail"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: Table vie delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DrinktipsCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
        
        
    }

}
