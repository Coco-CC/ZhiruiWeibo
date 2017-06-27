//
//  BaseViewController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/17.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    // MARK:- 定义变量
    var isLogin : Bool =  UserAccountViewModel.shareIntance.isLogin
    // MARK:- 系统回调函数
    override func loadView() {
        
        
       
        
        
        
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}

// MARK:- 设置UI界面
extension BaseViewController {
    /// 设置访客视图
    fileprivate func setupVisitorView() {
        view = visitorView
        
        // 监听访客视图中`注册`和`登录`按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
    
    /// 设置导航栏左右的Item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}


// MARK:- 事件监听
extension BaseViewController {
    @objc fileprivate func registerBtnClick() {
        print("registerBtnClick")
    }
    
    @objc fileprivate func loginBtnClick() {
        
        
        let oauthVC  = OAuthViewController()
        
        
        let oatuthNav = UINavigationController(rootViewController: oauthVC)
        
        
        
        present(oatuthNav, animated: true, completion: nil)
        
        print("loginBtnClick")
    }
}






