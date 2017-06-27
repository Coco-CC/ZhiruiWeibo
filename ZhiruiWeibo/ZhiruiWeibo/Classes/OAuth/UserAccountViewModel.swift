//
//  UserAccountTool.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/22.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class UserAccountViewModel{
    
    
    
    // MARK:- 将类设计成单利
    
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    
    
    
    // MARK:- 计算属性
    
    var account : UserAccount?
    var accountPath  : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
       return (accountPath as NSString).appendingPathComponent("accout.plist")
    
      
    }
    
    
    var isLogin : Bool {
    
        if account == nil {
            return false
        }
        
        guard  let expiresDate = account?.expires_date else {
            return false
        }
        
        
        
        
        return expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    
    }
    
    
    // MARK:- 重写init函数
    init(){
    
        account = NSKeyedUnarchiver.unarchiveObject(withFile:accountPath)as? UserAccount

    
    }

    
    
    
    

}
