//
//  UITextView-Extension.swift
//  EmojKey
//
//  Created by DIT on 2016/11/30.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

extension UITextView{


    
    // 
    func getEmoticonString() -> String {
        
        //1、获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        //2、 遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: [], using: {(dict,range,_) -> Void
            in
            
            if let attachment = dict["NSAttachment" ] as? EmoticonAttachment{
                
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
                
            }
            //3、获取字符串
        })
          return attrMStr.string  
    }
    
    
    
    
    
    
    //给textView插入表情
    func insertEmoticon(emoticon : Emoticon){
        //1、空白表情
        if emoticon.isEmpty {
            return
        }
        
        //2、删除按钮
        if emoticon.isRemove {
             deleteBackward()
            return
        }
        
        //3、emoji表情
        if emoticon.emojiCode != nil{
            
            //获取光标所在的位置
            let textRange =  selectedTextRange
            
             replace(textRange!, withText: emoticon.emojiCode!)
            
            return
        }
        
        //4.1根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        attachment.chs = emoticon.chs
        let font =  self.font
        attachment.bounds = CGRect(x: 0, y: -3, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let attrImageStr = NSAttributedString(attachment: attachment)
         
        //4.2创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString:  attributedText)
        
        
        //4.3 将图片属性字符串，替换到可变属性字符串的某一个位置
        //4.3.1 获取光标所在的位置
        let range =  selectedRange
        
        
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
         attributedText = attrMStr
        //将文字大小
         self.font = font
        //将光标设置回原来的位置 + 1
        
         selectedRange = NSRange(location: range.location + 1, length: 0)
    }

}
