//
//  PicPickerCollectionView.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/28.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15
class PicPickerCollectionView: UICollectionView {
    
    
    // MARK:- 定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        
        layout.itemSize = CGSize(width: itemH, height: itemH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        
        
        
        

        register(UINib(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        
        //设置collectionView 的内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
        
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



extension PicPickerCollectionView : UICollectionViewDelegate,UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerCell
        
        
     cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        //给cell设置数据
        
//        cell.backgroundColor = UIColor.red
        
        
        return cell
        
        
        
    }




}
