//
//  VoicePickerView.swift
//  Cool
//
//  Created by wyz on 16/4/20.
//  Copyright © 2016年 wyz. All rights reserved.
//

import UIKit
import AVFoundation

private let voiceCellIdentifier = "voiceCellIdentifier"
private var showAnimation = true
private let screenH = UIScreen.mainScreen().bounds.size.height
private let screenW = UIScreen.mainScreen().bounds.size.width
private let themeColor = UIColor(red: 64/255.0, green: 228/255.0, blue: 165/255.0, alpha: 1.0)

class VoicePickerView: UIView {
    var didSelectItemClosure: ((sound:RemindSound) -> Void)?
    
    var willHideClosure:(()->Void)?
    
    private var player:AVAudioPlayer?
    
    private let dataSource = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("sound", ofType: "plist")!) as! [RemindSound]

    private var selectCell:VoiceCollectionCell?
    
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: 0, y: screenH, width: screenW, height: screenH))
        
        addSubview(collectionView)
        backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: screenH - 170, width: self.frame.size.width, height: 170), collectionViewLayout:VoiceCollectionViewLayout() )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.pagingEnabled = false
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(VoiceCollectionCell.self, forCellWithReuseIdentifier: voiceCellIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        return collectionView
    }()
    
    func show() {
        hidden = false
        UIView.animateWithDuration(0.5, animations: { 
            self.transform = CGAffineTransformMakeTranslation(0, -screenH)
            }, completion: { (_) in
                
        })
        self.collectionView.reloadData()
        
    }
    
    func hide() {
        player?.stop()
        UIView.animateWithDuration(0.5, animations: {
              self.transform = CGAffineTransformIdentity
            }) { (_) in
                showAnimation = true
                self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                self.hidden = true
        }
        
        if willHideClosure != nil {
            willHideClosure!()
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hide()
    }
    
    func playMusicWithIndexPath(indexPath:NSIndexPath) {
        let reminSound = dataSource[indexPath.row]
        let audioName = reminSound.path
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioName, ofType: nil)!))
        } catch {
            return
        }
        
        player!.prepareToPlay()
        player!.play()
    }
    
    deinit{
        print(NSStringFromClass(self.classForCoder) + "释放")
    }
}

extension VoicePickerView:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(voiceCellIdentifier, forIndexPath: indexPath) as! VoiceCollectionCell
        let remindSound = dataSource[indexPath.row]
        cell.imageView.image = UIImage(named: remindSound.image)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
                if indexPath.row > 3 {
                    return
                }
                if !showAnimation {
                    return
                }
        let tranformScale = CGAffineTransformMakeScale(1, 1)
        let tranformTranslate = CGAffineTransformMakeTranslation(0, (CGFloat)((indexPath.row + 1) * 200))
        cell.transform = CGAffineTransformConcat(tranformScale, tranformTranslate)
        collectionView .bringSubviewToFront(cell)
                UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    cell.transform = CGAffineTransformIdentity
                    }, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        playMusicWithIndexPath(indexPath)
        
        if didSelectItemClosure != nil {
            didSelectItemClosure!(sound:dataSource[indexPath.row])
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
            showAnimation = false
    }
}

private class VoiceCollectionCell: UICollectionViewCell {
    
    
    override var selected: Bool {
        didSet{
            imageView.layer.borderWidth = selected ? 3 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
        contentView.addSubview(imageView)
        imageView.frame = self.bounds
        
        imageView.layer.borderColor = themeColor.CGColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
}

private class VoiceCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = CGSize(width: 90, height: 160)
//        minimumInteritemSpacing = 20
        minimumLineSpacing = 20
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
    
}
