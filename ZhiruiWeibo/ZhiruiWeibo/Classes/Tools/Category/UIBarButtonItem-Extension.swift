//
//  UIBarButtonItem-Extension.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/17.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit


extension UIBarButtonItem {


//    convenience init(imageName : String) {
//        
//        
//        self.init()
//        
//        let btn = UIButton()
//        
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        
//        self.customView = btn
//    }
    
    
    
    
    convenience init(imageName : String) {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
//        self.customView = btn
        self.init(customView : btn)
        
       
    }


}
