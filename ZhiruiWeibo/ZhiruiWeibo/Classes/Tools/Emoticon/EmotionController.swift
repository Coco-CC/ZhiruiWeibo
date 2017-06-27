//
//  EmotionController.swift
//  EmojKey
//
//  Created by DIT on 2016/11/29.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
private let EmoticonCell = "EmoticonCell"
class EmotionController: UIViewController {

    // MARK:- 定义属性
    var emotionCallBack : (_ emoticon : Emoticon) -> ()
    
    // MARK:- 懒加载属性
    
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    fileprivate lazy var manager = EmoticonManager()
    
    
    
    
    // MARK:- 自定义构造函数
    
    init(emotionCallBack : @escaping (_ emoticon : Emoticon) -> ()) {
    
        
    self.emotionCallBack = emotionCallBack
    super.init(nibName: nil, bundle: nil)
    
    

    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK:-  系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        setupUI()
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


// MARK:- 设置UI界面
extension EmotionController {

    
    
    fileprivate func setupUI(){
        
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        
        collectionView.backgroundColor = UIColor.white
//        toolBar.backgroundColor = UIColor.darkGray
        
        // 2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        
        
        // 3.准备collectionView
        prepareForCollectionView()
        
        // 4.准备toolBar
        prepareForToolBar()
    
    
    
    
    }
    
    
    
    private func prepareForCollectionView() {
        
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        // 1.定义toolBar中titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 2.遍历标题,创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.itemClick(item:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 3.设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc fileprivate func itemClick(item : UIBarButtonItem) {
//        print(item.tag)
        
        
        let tag = item.tag
        
        
        
        let indexPath = IndexPath(item: 0, section: tag)
        
        
        collectionView.scrollToItem(at: indexPath , at: .left, animated: true)
        
        
        
    }




}


extension EmotionController : UICollectionViewDataSource,UICollectionViewDelegate{


    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        let package = manager.packages[section]
        
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        
        // 2.给cell设置数据
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.blue
        
        
        let package = manager.packages[indexPath.section]
        
        let emotion = package.emoticons[indexPath.item]

        
        cell.emoticon = emotion
//        print(emotion)
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //1、取出点击的表情
        
        let package = manager.packages[indexPath.section]
        
        let emotion = package.emoticons[indexPath.item]
        //2、将点击的表情插入最近分组中
        
        
        
        insertRecentEmotion(emotion: emotion)
        
        emotionCallBack(emotion)
        
//        print(emotion)

        
        
    }
    
    
    
    fileprivate func insertRecentEmotion(emotion : Emoticon){
    
    
        if emotion.isEmpty || emotion.isRemove {
            return
        }
    
        
        // 2.删除一个表情
        if manager.packages.first!.emoticons.contains(emotion) { // 原来有该表情
            let index = (manager.packages.first?.emoticons.index(of: emotion))!
            manager.packages.first?.emoticons.remove(at: index)
        } else { // 原来没有这个表情
            manager.packages.first?.emoticons.remove(at: 19)
        }
        
        // 3.将emoticon插入最近分组中
        manager.packages.first?.emoticons.insert(emotion, at: 0)
        
    
    }
    
    
    


}


class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 3.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
