//
//  VisitorView.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/17.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    
    
    
    
    
    
    
    
    
    
    
    
    class func visitorView() -> VisitorView {
        
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    
    
    
    
    
    
    // MARK:-  空间的属性
    
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    // MARK:- 自定义函数
    
    
    func setupVisitorViewInfo(iconName : String ,title : String)  {
        iconImageView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
        
    }
    
    func addRotationAnim(){
        
        //1、创建动画
        
        let rorationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //2、设置动画的属性
        
        
        rorationAnim.fromValue = 0
        rorationAnim.toValue = M_PI * 2
        rorationAnim.repeatCount = MAXFLOAT
        rorationAnim.duration = 6
        rorationAnim.isRemovedOnCompletion = false
        
      
        //3、将动画添加到layer 中
        
        rotationView.layer.add(rorationAnim,forKey: nil)
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
