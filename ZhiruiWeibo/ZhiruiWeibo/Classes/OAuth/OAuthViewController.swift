//
//  OAuthViewController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/20.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
//        webView.loadRequest(NSURLRequest(url: NSURL(string: "http://www.baidu.com")! as URL) as URLRequest)
        
        
        loadPage()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK:- 设置UI界面相关
extension OAuthViewController {
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    
    
    fileprivate func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&response_type=code&redirect_uri=\(redirect_uri)"

        
        // 2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = NSURLRequest(url: url as URL)
        
        // 4.加载request对象
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
    }

}

// MARK:- 事件监听函数
extension OAuthViewController {
    @objc fileprivate  func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    @objc fileprivate func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='zhiruimaster@sina.cn';document.getElementById('passwd').value='caofa19931818';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }

    
}

// MARK:- webView的delegate方法
extension OAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView加载网页失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    
    //当准备加载某一个页面时会执行该方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        
        
        // 1.获取加载网页的NSURL
        guard let url = request.url else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        
        // 3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
    
//        // 5.请求accessToken
        loadAccessToken(code: code)
        
        
        
        
        return false
    }
}

// MARK:- 请求数据
extension OAuthViewController{
    
    
    fileprivate func loadAccessToken(code : String){
    
        CCNetworkTool.sharInStance.loadAccessToken(code: code, finished: {(result , error) -> () in
            // 1.错误校验
            if error != nil {
//                print(error ?? "123")
                return
            }
            
            // 2.拿到结果
            guard let accountDict = result else {
                print("没有获取授权后的数据")
                return
            }

//            print("")
//             3.将字典转成模型对象
            let account = UserAccount(dict: accountDict)
//            print(account)
        self.loadUserInfo(account: account)
        
            UserAccountViewModel.shareIntance.account = account
            
            //退出当前的控制器
            
            self.dismiss(animated: false, completion: { () -> Void in

                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
                
            })
            
            
        //显示欢迎界面
            
            
            
            
            
        
        })
    }
    

    
    /// 请求用户信息
    fileprivate func loadUserInfo(account : UserAccount) {
        // 1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        
        // 2.获取uid
        guard let uid = account.uid else {
            return
        }
        
        
        CCNetworkTool.sharInStance.loadUserInfo(access_token: accessToken, uid: uid, finished: {(result, error) in
            
            // 1.错误校验
            if error != nil {
//                print(error ?? "error")
                return
            }
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            //4、将account对象保存
            //获取沙河路径
//            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            accountPath = (accountPath as NSString).appendingPathComponent("accout.plist")
//
//            
//            print(accountPath)
//            
            // 4.2.保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile:UserAccountViewModel.shareIntance.accountPath)
        })
        
        

    }
}



