//
//  EmotionCell.swift
//  EmojKey
//
//  Created by DIT on 2016/11/29.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    
    
    
    // MARK:- 懒加载属性
    
    
    fileprivate lazy var emotionBtn : UIButton = UIButton()
    
    
    // MARK:- 定义属性
    var emoticon : Emoticon? {//= Emoticon()
        
        
        didSet {
            
            guard  let emoticon = emoticon else {
                return
            }
            
            emotionBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emotionBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            // 2.设置删除按钮
            if emoticon.isRemove {
                emotionBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            //            print(emoticon.pngPath ?? "asd")
        }
        
         
    }
    
    // MARK:- 重写构造函数
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




extension EmoticonViewCell {
    
    fileprivate func setupUI(){
        
        //1、添加子控件
        contentView.addSubview(emotionBtn)
        emotionBtn.frame = contentView.bounds
        //设置btn的属性
        emotionBtn.isUserInteractionEnabled = false
        emotionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        
        
        
        
    }
    
    
}
