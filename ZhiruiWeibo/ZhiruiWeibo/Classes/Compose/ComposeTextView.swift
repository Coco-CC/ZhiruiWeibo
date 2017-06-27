//
//  ComposeTextView.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/28.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {

    
    // MARK:- 懒加载属性
     lazy var placeHolderLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
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
extension ComposeTextView {
    fileprivate func setupUI() {
        // 1.添加子控件
        addSubview(placeHolderLabel)
        
        // 2.设置frame
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(7)
            make.left.equalTo(10)
        }
        
        // 3.设置placeholderLabel属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        
        // 4.设置placeholderLabel文字
        placeHolderLabel.text = "分享新鲜事..."
        
        // 5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
