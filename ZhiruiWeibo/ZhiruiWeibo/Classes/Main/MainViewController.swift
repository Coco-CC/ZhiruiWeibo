//
//  MainViewController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/16.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    // MARK:- 懒加载属性
    fileprivate lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComposeBtn()
    }
}


// MARK:- 设置UI界面
extension MainViewController {
    /// 设置发布按钮
    fileprivate func setupComposeBtn() {
        // 1.将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        
        // 2.设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        // 3.监听发布按钮的点击
        // Selector两种写法: 1>Selector("composeBtnClick") 2> "composeBtnClick"
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
}


// MARK:- 事件监听
extension MainViewController {
    // 事件监听本质发送消息.但是发送消息是OC的特性
    // 将方法包装成@SEL --> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
    // 如果swift中将一个函数声明称private,那么该函数不会被添加到方法列表中
    // 如果在private前面加上@objc,那么该方法依然会被添加到方法列表中
    @objc fileprivate func composeBtnClick() {
//        print("composeBtnClick")
        
        
        //1、创建发布控制器
        
        let composeVC = ComposeViewController()
        
        //2、包装导航控制器
        
        let composeNav = UINavigationController(rootViewController: composeVC)
        
        //3、弹出控制器
        
        present(composeNav, animated: true, completion: nil)
        
        
        
    }
}












