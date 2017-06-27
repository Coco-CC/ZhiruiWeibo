//
//  PicCollectionViewCell.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/24.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionViewCell: UICollectionViewCell {
    
    
    var picURL : URL? {
    
        didSet{
        
            guard let picURL = picURL else {
                return
            }
            
            
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named:"empty_picture"))
        
        
        }
    
    
    
    }
    
    
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
    }
    
    
}
