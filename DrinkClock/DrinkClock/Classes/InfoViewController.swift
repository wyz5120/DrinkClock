//
//  InfoViewController.swift
//  DrinkClock
//
//  Created by wyz on 16/4/18.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = "reuseIdentifier"

class InfoViewController: UIViewController {

    var image: UIImage?
    
    
    let dataSource = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("drinkInfo", ofType: "plist")!)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("cancelBtnWhite", target: self, action: #selector(InfoViewController.dismissAction))
        
        view.addSubview(bgImageView)
        view.addSubview(visualEffectView)
        view.addSubview(infoCollectionView)
        view.addSubview(pageControl)
        view.addSubview(rateButton)
        view.addSubview(versionLabel)
      
        
        rateButton.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-scaleFromIphone5Height(20))
        }
        
        versionLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.rateButton.snp_top).offset(-scaleFromIphone5Height(10))
        }
        
        pageControl.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.versionLabel.snp_top).offset(-scaleFromIphone5Height(20))
            make.height.equalTo(20)
        }
        
    }
    
    //返回按钮
    func dismissAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = self.image
        return imageView
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.alpha = 1.0
        visualEffectView.frame = self.bgImageView.bounds
        return visualEffectView
    }()

    private lazy var infoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: InfoCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(infoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
          let pageControl = UIPageControl()
        pageControl.userInteractionEnabled = false
        pageControl.numberOfPages = self.dataSource.count
        return pageControl
    }()
    
    private lazy var rateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "GloberSemiBold", size: scaleFromIphone5Width(15))
        button.setTitle("支持我们,请给我们好评", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(InfoViewController.rateAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(scaleFromIphone5Width(14))
        label.text = (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    func rateAction() {
        let appURL = NSURL.init(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1078608745&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")
        UIApplication.sharedApplication().openURL(appURL!)
    }
}

// MARK: - 数据源
extension InfoViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! infoCell
        
        let dict = self.dataSource[indexPath.item] as! NSDictionary
        cell.timeLabel.text = (dict.valueForKey("time") as! String)
        cell.tipLabel.text = (dict.valueForKey("tip") as! String)
        cell.imageView.image = UIImage(named: (dict.valueForKey("image") as! String))
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = (Int)((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width)
        self.pageControl.currentPage = page
    }
}

// MARK: - 自定义Cell
class infoCell:UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(tipLabel)
        contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            make.width.equalTo(scaleFromIphone5Width(120))
            make.height.equalTo(scaleFromIphone5Height(150))
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(self.contentView.bounds.size.height * 0.20)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.imageView.snp_bottom).offset(scaleFromIphone5Height(20))
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.timeLabel.snp_bottom).offset(scaleFromIphone5Height(10))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greenColor()
        label.font = UIFont(name: "GloberxBold", size: scaleFromIphone5Width(25))
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cyanColor()
        label.font = UIFont(name: "GloberSemiBold", size: scaleFromIphone5Width(14))
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = scaleFromIphone5Width(10)
        imageView.layer.masksToBounds = true
        return imageView
    }()
}


// MARK: - 自定义布局
private class InfoCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
    
}
