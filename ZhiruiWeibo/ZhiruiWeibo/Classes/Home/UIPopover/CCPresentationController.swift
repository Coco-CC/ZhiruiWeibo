//
//  CCPresentationController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/17.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class CCPresentationController: UIPresentationController {
    
    
    // MARK:- 对外提供属性
    
    var presentedFrame : CGRect = CGRect()
    
    
    
    fileprivate lazy var coverView : UIView = UIView()
    
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        
        
//
        //1、设置弹出View的尺寸
        presentedView?.frame = presentedFrame //CGRect(x:UIScreen.main.bounds.size.width / 2.0 - 90 , y: 55, width: 180, height: 260)
        
        
        //2、添加蒙版
        
        setupCoverView()
        
    }
    
}


// MARK:- 设计UI界面相关


extension CCPresentationController{
    
    fileprivate func setupCoverView(){
        
        //1、添加蒙版
        containerView?.insertSubview(coverView, at: 0) //addSubview(coverView)
        
        //2、设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
        
        coverView.frame = containerView!.bounds
        
        
        //3、添加手势
        
        
   
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(CCPresentationController.coverViewClick))
        
        coverView.addGestureRecognizer(tapGesture)
        
        
    }
}

extension CCPresentationController{
    
    @objc fileprivate func coverViewClick(){
//        print("coverViewClick")
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }


}



