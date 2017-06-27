//
//  StatusViewModel.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/24.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    
    // MARK:- 定义属性
    var status : Status?
    
    
     var cellHeight : CGFloat = 0
    var sourceText :String?     //处理来源
    var createAtText : String? // 处理创建时间
    var verifiedImage : UIImage?   //处理用户认证图标
    var vipImage : UIImage? //处理会员等级
    var profileURL : URL? //用户头像的处理 地址
    var picURLs : [NSURL] = [NSURL]()   // 处理微博配图的数据
    
    
    
    // MARK:- 自定义构造函数
    init(status : Status) {
        self.status = status
        
        //对来源进行处理
        if let source = status.source,status.source != ""{
                //对来源的字符串进行处理
                //获取起始位置
                let startIndex = (source as NSString).range(of: ">").location + 1
                let length = (source as NSString).range(of: "</").location  - startIndex
                sourceText = (source as NSString).substring(with: NSRange(location : startIndex,length : length))
        }
        //对创建时间进行处理
        if let createAt = status.created_at {
          
            createAtText = NSDate.createDateString(createAtStr: createAt)
        }
        
        //对认证进行处理
         let  verifiedType = status.user?.verified_type ?? -1
        
            switch verifiedType {
            case 0:
                
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
                
            }
        
        
        
        //对会员图标进行处理
         let mbrank = status.user?.mbrank ?? 0
        
            if mbrank > 0 && mbrank <= 6 {
                vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        
        
        
        
        //用户头像的处理 地址
        
        
        // 5.用户头像的处理
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileURLString) as URL?
        
        //处理微博配图的
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
        
            for picURLDicts in picURLDicts {
            
            
                guard  let picURLString = picURLDicts["thumbnail_pic"] else{
                continue
                }
                
                
                picURLs.append(URL(string: picURLString)! as NSURL)
                
                
              
            
            }
        
        }
        
        
        
    }
}
