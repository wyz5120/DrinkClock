//
//  ViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 50, green: 50, blue: 50, alpha: 0.2)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("menuBtn", target: self, action: #selector(HomeViewController.menuAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem.item("infoBtn", target: self, action: #selector(HomeViewController.infoAction))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func menuAction() {
        print(#function)
    }
    
    func infoAction() {
        print(#function)
    }
    
   
}

