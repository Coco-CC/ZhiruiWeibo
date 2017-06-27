//
//  CCNetworkTool.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/20.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

import AFNetworking

enum CCRequestType {
    
    case GET
    case POST
    
}


class CCNetworkTool: AFHTTPSessionManager {
    
    
    static let sharInStance : CCNetworkTool = {
        
        let toolInstance = CCNetworkTool()
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/html")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("application/json;charset=UTF-8")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("application/json")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/javascript")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/json")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/plain;charset=UTF-8")
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/html;charset=utf-8")
        
        
        
        
        //        toolInstance.requestSerializer = AFHTTPRequestSerializer()//.serializer()
        //        toolInstance.responseSerializer = AFHTTPResponseSerializer()
        //AFJSONRequestSerializer.serializer()//[AFJSONRequestSerializer serializer];
        //        toolInstance.responseSerializer = AFHTTPResponseSerializer.serializer();
        //        toolInstance.requestSerializer.timeoutInterval = 10;
        
        
        return toolInstance
    }()
    
    
    
    
    //    // 将成功和失败的回调写在一个逃逸闭包中
    func request(requestType : CCRequestType, url : String, parameters : [String : Any], resultBlock : @escaping([String : Any]?, Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            resultBlock(nil, error)
        }
        
        // Get 请求
        
        
        switch requestType {
        case .GET:
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        case .POST:
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        
    }
    
    // 将成功和失败的回调分别写在两个逃逸闭包中
    func request(requestType : CCRequestType, url : String, parameters : [String : Any], succeed : @escaping([String : Any]?) -> (), failure : @escaping(Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            
            
            
            print(responseObj!)
            succeed(responseObj as? [String : Any])
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // Get 请求
        if requestType == .GET {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .POST {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    
    
    
}
// MARK:- 请求AccessToken

extension CCNetworkTool{
    
    
    
    func  loadAccessToken(code : String, finished : @escaping (_ result : [String : AnyObject]?, _ error : NSError?) -> ()) {
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        
        
        //发送网络请求
        
        
        
        request(requestType: .POST, url: urlString, parameters: parameters, resultBlock:{
            
            (result,error) -> () in
            
            
            finished(result as? [String : AnyObject], error as NSError?)
            
        })
        
        
        
        
        
        
    }
}


// MARK:- 请求用户的信息
extension CCNetworkTool{
    
    func loadUserInfo(access_token : String , uid : String,finished: @escaping (_ result : [String : AnyObject]? , _ error : NSError?) -> ()) {
        
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        // 3.发送网络请求
        
        
        request(requestType: .GET, url: urlString, parameters: parameters, resultBlock:  { (result, error) -> () in
            finished(result as? [String : AnyObject] , error as NSError?)
        }
        )
        
        
    }
    
    
}

// MARK:- 请求首页数据
extension CCNetworkTool{
    
    
    
    
    func loadStatues(since_id : Int, max_id: Int,finished :@escaping (_ result : [[String : AnyObject] ]? , _ error : NSError?) -> ()){
        
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!,"since_id":"\(since_id)","max_id":"\(max_id)"]
        
        
        
        
        
        // 3.发送网络请求
        
        
        request(requestType: .GET, url: urlString, parameters: parameters, resultBlock:  { (result, error) -> () in
            // 1.获取字典的数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error as NSError?)
                return
            }
            
            // 2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error as NSError?)
        }
        )
        
        
        
    }
    
    
    
}


// MARK:- 发送微博
extension CCNetworkTool{
    
    
    
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool) -> ())  {
        
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
        
        request(requestType: .POST, url: urlString, parameters: parameters, resultBlock:  { (result, error) -> () in

            if result != nil {
            
            isSuccess(true)
            
            }else{
            
            isSuccess(false)
            }
 
        }
        )
    }
}

// MARK:- 发送微博并且携带照片
extension CCNetworkTool {
    func sendStatus(statusText : String, image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
      
        post(urlString, parameters: parameters, constructingBodyWith:  { (formData) -> Void in
            
                        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                            formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
                        }
                        
        }, progress: nil, success: { (_, _) -> Void in
                        isSuccess(true)
        }, failure: { (_, error) -> Void in
                        print(error)
                    })

    }
}


