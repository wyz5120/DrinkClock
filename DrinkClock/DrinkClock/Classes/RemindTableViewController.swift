//
//  RemindTableViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/19.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let remindCellIdentifier = "remindCellIdentifier"
class RemindTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         view.backgroundColor = UIColor.yellowColor()
        
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(RemindCell.self, forCellReuseIdentifier: remindCellIdentifier)
        tableView.rowHeight = 60
        return tableView
    }()


}

extension RemindTableViewController:UITableViewDataSource,UITableViewDelegate {
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(remindCellIdentifier) as! RemindCell
//        cell.timel
        cell.timeLabel.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
