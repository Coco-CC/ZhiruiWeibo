//
//  ComposeTitleView.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/28.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {
    
    // MARK:- 懒加载控件
    
    
    fileprivate lazy var titleLabel : UILabel = UILabel()
    fileprivate lazy var screenNameLabel : UILabel = UILabel()
    
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupUI()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK:- 设置UI界面
extension ComposeTitleView{


    fileprivate func setupUI(){
        
        
        //1、将子控件添加到View
        addSubview(titleLabel)
        addSubview(screenNameLabel)
    
    //2、设置frame
        
        // 2.设置frame
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        // 3.设置空间的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        // 4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    
    
    }



}
