//
//  UserAccount.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/22.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class UserAccount: NSObject , NSCoding {
    
    /// 授权AccessToken
    var access_token : String?
    /// 过期时间-->秒
    var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 用户ID
    /// 用户ID
    var uid : String?
    
    /// 过期日期
    var expires_date : NSDate?
    /// 昵称
    var screen_name : String?
    
    /// 用户的头像地址
    var avatar_large : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
    //
    //
    //    // MARK:- 重写description属性
    override var description : String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid","screen_name", "avatar_large"]).description
    }
    
    
    // MARK:- 归档&解档
    /// 解档的方法
  
    
    
    required init(coder aDecoder : NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
    
    /// 归档方法

    // MARK:- 处理需要归档的字段
    func encode(with aCoder:NSCoder) {
        
        aCoder.encode(access_token, forKey:"access_token")
        aCoder.encode(uid, forKey:"uid")
        aCoder.encode(expires_date, forKey:"expires_date")
        aCoder.encode(avatar_large, forKey:"avatar_large")
        aCoder.encode(screen_name, forKey:"screen_name")
       
       
    }
    
    
    
    override init() {
       super.init()
    }
    
    
}
