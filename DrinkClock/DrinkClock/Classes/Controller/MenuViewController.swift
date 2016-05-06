//
//  MenuViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/25.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

private let menuCellIdentifier = "menuCellIdentifier"

private let rowCount = 3

private let titleArray = ["饮水计划推荐","喝水小贴士","补水果蔬"]
private let imageArray = ["flower1","tip.jpeg","garden"]

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
        view.addSubview(tableView)
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: menuCellIdentifier)
        tableView.rowHeight = (screenHeight - topHeight) / (CGFloat)(rowCount)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clearColor()
        return tableView
    }()

}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier) as! MenuCell
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.bgView.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { //饮水计划推荐
            let sb = UIStoryboard(name: "main", bundle: NSBundle.mainBundle())
            let drinktipsVc = sb.instantiateViewControllerWithIdentifier("plan")
            navigationController?.pushViewController(drinktipsVc, animated: true)
        }
        
        if indexPath.row == 1 { //喝水小贴士
            let sb = UIStoryboard(name: "main", bundle: NSBundle.mainBundle())
            let drinktipsVc = sb.instantiateViewControllerWithIdentifier("drinktips")
            navigationController?.pushViewController(drinktipsVc, animated: true)
        }
        
        if indexPath.row == 2 { //补水果蔬
            let sb = UIStoryboard(name: "main", bundle: NSBundle.mainBundle())
            let gardenVc = sb.instantiateViewControllerWithIdentifier("garden")
            navigationController?.pushViewController(gardenVc, animated: true)
        }
    }
}
