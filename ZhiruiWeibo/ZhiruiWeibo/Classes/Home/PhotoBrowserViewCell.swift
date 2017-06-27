//
//  PhotoBrowserCell.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/12/1.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
    
}



class PhotoBrowserViewCell: UICollectionViewCell {
    
    // MARK:- 定义属性
    var picURL : URL?{
    
        didSet {
            
            
            
        setupContent(picURL: picURL)
        }
    
    
    }
    
      var delegate : PhotoBrowserViewCellDelegate?
    // MARK:- 懒加载属性
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
       public      lazy var imageView : UIImageView = UIImageView()
        fileprivate lazy var progressView : ProgressView = ProgressView()
    
    //构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK:- 设置UI界面
extension PhotoBrowserViewCell{

    
    fileprivate func setupUI(){
    
    //1、添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        // 2.设置子控件frame
        scrollView.frame = contentView.bounds
        
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        
        // 3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        
        //4、监听imageView的点击
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.imageViewClick))
        
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
        
        
    }
}

extension PhotoBrowserViewCell{


    @objc fileprivate func imageViewClick() {
        
        
        delegate?.imageViewClick()
    }



}



extension PhotoBrowserViewCell{
    
    
    fileprivate func setupContent(picURL : URL?){
        
        
        //            print(picURL ?? "123")
        //1、 nil值校验
        guard let picURL = picURL else {
            return
        }
        
        
        
        
        //2、取出image对象
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //3、计算imageView 的frame
        //            let x = 0
        let width = UIScreen.main.bounds.width
        let height = width / (image?.size.width)! * (image?.size.height)!
        
        var y : CGFloat = 0
        
        if height > UIScreen.main.bounds.height {
            y = 0
        }else{
            
            y = (UIScreen.main.bounds.height - height) * 0.5
            
        }
        
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        
        
        //5、设置imageView的图片
        imageView.image = image
        // 4.设置imagView的图片
        progressView.isHidden = false

        imageView.sd_setImage(with: getBigURL(smallURL: picURL), placeholderImage: image, options: [], progress: { (current, total) -> Void in
            
            print( CGFloat(current) / CGFloat(total))
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) -> Void in
            self.progressView.isHidden = true
        }
        
        
        
       
        
        
        scrollView.contentSize = CGSize(width: 0 , height : height)
    }
    
    
    fileprivate func getBigURL(smallURL : URL) -> URL {
        let smallURLString = smallURL.absoluteString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: bigURLString)!
    }
    
    
    
}
