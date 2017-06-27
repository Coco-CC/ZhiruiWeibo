//
//  PhotoBrowserController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/12/1.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
private let PhotoBrowserCell = "PhotoBrowserCell"
class PhotoBrowserController: UIViewController {

    
    
    
    var  indexPath : IndexPath
    var picURLs : [URL]
    
    
    
    // MARK:- 懒加载属性
    
    fileprivate lazy var collctionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewFlowLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
 
    fileprivate lazy var saveBtn = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    
    
    
    
    init(indexPath : IndexPath , picURLs : [URL]){
     self.indexPath = indexPath
    self.picURLs = picURLs
        
        
    super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        view.backgroundColor = UIColor.purple
        
        
        //1、设置UI界面
          setupUI()
        // 2.滚动到对应的图片
        collctionView.scrollToItem(at: indexPath, at: .left, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension PhotoBrowserController : PhotoBrowserViewCellDelegate {

    func imageViewClick() {
        closeBtnClick()
    }


}


// MARK:- 设置UI界面
extension PhotoBrowserController {

    fileprivate func setupUI(){
        //1、添加控件
        view.addSubview(collctionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        
        //2、设置frame
        collctionView.frame = view.bounds
        closeBtn.frame = CGRect(x: 20, y: UIScreen.main.bounds.height - 52, width: 90, height: 32)
        saveBtn.frame = CGRect(x: UIScreen.main.bounds.width - 110, y: UIScreen.main.bounds.height - 52, width: 90, height: 32)
        
        //3、设置collectionViewcell
        
        collctionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        
        collctionView.dataSource = self
       
        
        
        
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), for: .touchUpInside)
    
    }


}


// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClick() {
//        print("saveBtnClick")
        //1、获取当前正在显示的image
        let cell =  collctionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        // 2.将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image), nil)
        
        
        
    }
    
    

    
    
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
    
}

extension PhotoBrowserController : UICollectionViewDataSource{

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return  picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
         cell.delegate = self
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.orange : UIColor.yellow
        // 2.给cell设置数据
        
        

        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
        
    }
    

    
    
    
    


}



class PhotoBrowserCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    
    override func prepare() {
        
        super.prepare()
        
        //1、设置itemSize
        itemSize = (collectionView?.frame.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        
    }
    
    
}

// MARK:- 遵守AnimatorDismissDelegate
extension PhotoBrowserController : AnimatorDismissDelegate {
    
    func indexPathForDimissView() -> NSIndexPath {
        // 1.获取当前正在显示的indexPath
        let cell = collctionView.visibleCells.first!
        
        return collctionView.indexPath(for: cell)! as NSIndexPath
    }
    
    func imageViewForDimissView() -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.设置imageView的frame
        let cell = collctionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        // 3.设置imageView的属性
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
    }
}



