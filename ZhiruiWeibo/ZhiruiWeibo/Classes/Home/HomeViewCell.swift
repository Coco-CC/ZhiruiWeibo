//
//  HomeViewCell.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/24.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SDWebImage


private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10


class HomeViewCell: UITableViewCell {
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var bottomToolsView: UIView!
    @IBOutlet weak var reweetedBgView: UIView!
    
    @IBOutlet weak var PicCollectionView: PicCollectionView!
    // MARK:- 控件属性
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    
    
    
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    // MARK:- 约束属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!

    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    // MARK:- 自定义属性
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var retweetedTopCons: NSLayoutConstraint!
    
    
    var viewModel : StatusViewModel? {
    
 
        didSet{
        
        
        //nil值校验
            
            guard let viewModel = viewModel else {
                return
            }
            
            
//            vipImageView.
            
            //设置头像
            iconImageView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named:"avatar_default_small"))
            
            
            //设置认证图标
            
            verifiedView.image = viewModel.verifiedImage
            
            //昵称
            
            screenNameLabel.text = viewModel.status?.user?.screen_name
            
            //会员图标
            vipImageView.image = viewModel.vipImage
            //设置时间的Label
            timeLabel.text = viewModel.createAtText
            //设置来源
            
            
            
            
            if let sourceText  = viewModel.sourceText {
                
              sourceLabel.text = "来自 " + sourceText
            }else{
            
            sourceLabel.text = nil
            }
            
            
            //微博内容
            
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            
            //设置昵称的文字颜色
            
            
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            
            //计算picView的宽度和高度的约束
            
            
            
            //        print(viewModel?.picURLs.count)
            
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            
            
            
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            
            
            //将picURLs的数据穿个picView
            
            
            picView.picURLs = viewModel.picURLs as [URL]
            
            
            //设置转发微博的正文
            
            
            
            if viewModel.status?.retweeted_status != nil {
                
                
                
                // 1、设置转发微博的正文
                
                if  let screenName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetedText = viewModel.status?.retweeted_status?.text{
                
                    let retweetedText = "@" + "\(screenName): " + retweetedText
                    retweetedContentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: retweetedText, font: retweetedContentLabel.font)
                    
                    // 设置转发正文距离顶部的约束
//                    retweetedContentLabel.constant = 15
//                 retweetedContentLabel.text = "@" + "\(screenName): " +  retweetedText
                }
                
                //设置转发正文距离顶部的约束
                retweetedTopCons.constant = 15
                
            
                // 2、设置背景显示
                
                reweetedBgView.isHidden = false
               
            }else{
            
            
            retweetedContentLabel.text = nil
                
                
                // 2、设置背景显示
                
                reweetedBgView.isHidden = true

                //设置转发正文距离顶部的约束
                retweetedTopCons.constant = 0
            }
            
            
            
            if viewModel.cellHeight == 0 {
                
                
                layoutIfNeeded()
                
                viewModel.cellHeight = bottomToolsView.frame.maxY
                
            }
            

            
        
        }
    
    
    }
    
    
    
    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.size.width - 2 * edgeMargin
        
        
//        //取出picView对应的layout
//        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
//        
//        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
//        
//        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
// MARK:- 计算方法
extension HomeViewCell{

    
    fileprivate func calculatePicViewSize(count : Int) -> CGSize{
    
        
        
        //1、没有配图
        
        if count == 0 {
            
            picViewBottomCons.constant = 0
        return CGSize(width: 0, height: 0)
        }
        
        picViewBottomCons.constant = 10
        //取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
    
        
        
        //单张配图
        
        if count == 1 {
        
       let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: viewModel?.picURLs.first?.absoluteString)
       
        
        layout.itemSize =  CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        return CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            
        }
        
        
        
    
        
        
        
        
        //2、 计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
      
        //设置其他张图片时
        
        layout.itemSize = CGSize(width: imageViewWH, height:imageViewWH)
        
        //3、四张配图
        if count == 4 {
         let picViewWH = imageViewWH * 2 + itemMargin
        return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //4 、其它张配图
        
        //4.1 计算行数
        let rows =  CGFloat((count - 1) / 3 + 1)
        //4.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        //4.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }


}



