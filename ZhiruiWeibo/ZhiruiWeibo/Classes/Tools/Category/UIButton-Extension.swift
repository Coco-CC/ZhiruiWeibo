//
//  UIButton-Extension.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/16.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit


extension UIButton {
    
    
//    Swift中类方法是class开头的方法，类似于OC中的+开头的方法
        class func createButton(imageName : String ,bgImageName : String) -> UIButton{
            //1、创建btn
            let btn = UIButton()
            // 2.设置属性
            btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
            btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
            return btn
        }
    //convenience : 便利，使用convenience修饰的构造函数叫做便利构造函数
    //便利构造函数通常用在对系统的类进行构造函数的扩充时使用
    
    
    /*
     1、便利构造函数通常都是写在extesion里面
     2、便利构造函数init前面需要加载convenience
     3、在便利构造函数中需要明确的调用self.init()
     
     */
    convenience init(imageName : String,bgImageName : String){
        
        
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        
        setBackgroundImage(UIImage(named:bgImageName), for: .normal)
        setBackgroundImage(UIImage(named:bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    
    convenience init(bgColor : UIColor ,fontSize : CGFloat , title : String){
    
    self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
    
    }
    
    
}

