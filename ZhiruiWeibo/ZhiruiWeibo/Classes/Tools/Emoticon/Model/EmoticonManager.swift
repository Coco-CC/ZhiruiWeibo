//
//  EmoticonManager.swift
//  EmojKey
//
//  Created by DIT on 2016/11/29.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
//: NSObject
class EmoticonManager {
    
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        
        //1、添加最近表情的包
        packages.append(EmoticonPackage(id : ""))
        //2、添加默认表情的包
        packages.append(EmoticonPackage(id : "com.sina.default"))
        //3、添加emoji表情的包
        packages.append(EmoticonPackage(id : "com.apple.emoji"))
        //4、添加浪小花表情的包
        packages.append(EmoticonPackage(id : "com.sina.lxh"))
 
        
        
        
    }
    

}
