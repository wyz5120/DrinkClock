//
//  ViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private let remindVc = RemindTableViewController()
    
    var showMenu = false
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 50, green: 50, blue: 50, alpha: 0.2)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        setupNav()
        setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addButtonAnimation(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        addButtonAnimation(false)
    }
    
    // MARK: - 界面
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("menuBtn", target: self, action: #selector(HomeViewController.menuAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem.item("infoBtn", target: self, action: #selector(HomeViewController.infoAction))
        
        let titleView = TitleSwitchView()
        titleView.frame.size.width = screenWidth * 0.5
        titleView.frame.size.height = 36
        navigationItem.titleView = titleView
        titleView.buttonClickAction = {[weak self](buttonTag) -> Void in
            self!.centerViewAnimation(buttonTag)
        }
    }
    
    private func setupSubViews() {
        addChildViewController(remindVc)
        view.addSubview(bgImageView)
        view.addSubview(addButton)
        view.addSubview(homeView)
        view.addSubview(remindView)
        
        addButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view.snp_bottom).offset(-30)
            make.width.height.equalTo(0)
        }
        homeView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 80, left: 20, bottom: 60, right: 20))
        }
        
        remindView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 80 + screenHeight, left: 20, bottom: 60 - screenHeight, right: 20))
        }
    }
    // MARK: - 懒加载
    private lazy var bgImageView:UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = UIImage(named: "flower")
        return imageView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addTaskBtn"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(HomeViewController.addButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var homeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brownColor()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var remindView: UIView = {
        let view = self.remindVc.view
//        view.layer.cornerRadius = 20
//        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - 响应事件
    func menuAction() {
        showMenu = !showMenu
        let frame = navigationController?.navigationBar.frame
        for button in (navigationController?.navigationBar.subviews)! {
            if !button.isKindOfClass(UIButton) {
                continue
            }
            if button.frame.origin.x < frame!.size.width * 0.5 {
                
                if showMenu {
                    UIView.animateWithDuration(0.5, animations: {
                        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                        self.navigationItem.titleView?.alpha = 0.0
                    })
                } else {
                    UIView.animateWithDuration(0.5, animations: { 
                        button.transform = CGAffineTransformIdentity
                        self.navigationItem.titleView?.alpha = 1.0
                    })
                }
             
            }
        }

   
        
    }
    
    func infoAction() {
        
        let infoVc = InfoViewController()
        infoVc.image = UIImage.imageWithCaptureOfView(view)
        let navigationVc = NavigationController(rootViewController: infoVc)
        navigationVc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(navigationVc, animated: true, completion: nil)
    }
    
    private func addButtonAnimation(show: Bool) {
      
        if show {
            addButton.snp_remakeConstraints(closure: { (make) in
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view.snp_bottom).offset(-30)
                make.width.height.equalTo(45)
            })
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.addButton.layoutIfNeeded()
                }, completion: nil)
        } else {
            addButton.snp_remakeConstraints { (make) in
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view.snp_bottom).offset(-45)
                make.width.height.equalTo(0)
            }
        }
    }
    
    func addButtonAction() {
        let navigationVc = NavigationController(rootViewController: AddReminderViewController())
        presentViewController(navigationVc, animated: true, completion: nil)
    }
    
    private let animationDuration = 0.3
    private let damp:CGFloat = 0.8
    private let velocity:CGFloat = 4
    func centerViewAnimation(buttonTag: NSInteger) {
        if buttonTag == 101 {
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: damp, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.remindView.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    UIView.animateWithDuration(self.animationDuration, delay: 0, usingSpringWithDamping: self.damp, initialSpringVelocity: self.velocity, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                         self.homeView.transform = CGAffineTransformIdentity
                        }, completion:{ (_) in
                     })
            })
        } else {
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: damp, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.homeView.transform = CGAffineTransformMakeTranslation(0, screenHeight)
                }, completion: { (_) in
                    UIView.animateWithDuration(self.animationDuration, delay: 0, usingSpringWithDamping: self.damp, initialSpringVelocity: self.velocity, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.remindView.transform = CGAffineTransformMakeTranslation(0, -screenHeight)
                        }, completion: { (_) in
                    })
            })
        }
    }

}

