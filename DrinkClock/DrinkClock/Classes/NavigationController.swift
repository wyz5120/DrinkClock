//
//  NavigationController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setValue(NavigationBar(), forKeyPath: "NavigationBar")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
         
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.item("menuBtn", target: self, action: #selector(NavigationController.popAction))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func popAction() {
        popViewControllerAnimated(true)
    }
}
