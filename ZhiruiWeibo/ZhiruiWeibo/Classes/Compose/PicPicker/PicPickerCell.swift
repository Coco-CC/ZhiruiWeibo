//
//  PicPickerCell.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/28.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {

 
    
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var removePhotoBtn: UIButton!
 
    // MARK:- 定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                
                photoImageView.image = image
                
//                addPhotoBtn.setBackgroundImage(image, for: .normal)
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
                
            } else {
                photoImageView.image  = nil
//                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                addPhotoBtn.isUserInteractionEnabled = true
                removePhotoBtn.isHidden = true
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


extension PicPickerCell{


    @IBAction func removePhotoClick(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: photoImageView.image)
        

        
//        PicPickerRemovePhotoNote
    }
    
    
    @IBAction func addPhotoClickAction(_ sender: Any) {
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        //1、判断照片源是否可用
//        
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//        
//        return
//        
//        }
//        
//        
//        //2、创建照片选择控制器
//        let ipc = UIImagePickerController()
//        
//        
//        //3、设置照片源
//        
//        ipc.sourceType = .photoLibrary
//        
        
        
        
        
        
    }


}
