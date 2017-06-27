//
//  PicCollectionView.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/24.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionView: UICollectionView {
    
    // MARK:- 定义属性
    var picURLs : [URL] = [URL](){
        
        didSet {
            
            self.reloadData()
        }
        
    }
    
    
    
    // MARK:- 系统回调的函数
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
        dataSource = self
        delegate = self
        //        delegate = self
        
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}




extension PicCollectionView : UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
//        print("------------------\(picURLs.count)")
        return picURLs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1、 获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollectionViewCell", for: indexPath) as! PicCollectionViewCell
        
        // 2、 给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        
        return cell
    }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          print(indexPath.item)
        
        
        //1、获取通知需要传递的参数
  
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlKey : picURLs] as [String : Any]
  
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: self, userInfo: userInfo)
        
        
        
    }

    
    
    
    
    
}


extension PicCollectionView : AnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        
        // 2.获取cell的frame
        let startFrame =  self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        // 1.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 2.计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 3.设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}




