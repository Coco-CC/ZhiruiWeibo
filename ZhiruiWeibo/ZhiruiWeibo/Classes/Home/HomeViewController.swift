//
//  HomeViewController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/16.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh


class HomeViewController: BaseViewController {
    
    
    // MARK:- 懒加载属性
    
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    // 注意：在闭包中如果使用当前对象的属性或者调用方法，要加self
    fileprivate lazy  var popoverAnimator : PopoverAnimator = PopoverAnimator{[weak self] (presented) in
        
        
        self?.titleBtn.isSelected = presented
        
    }
    
    fileprivate lazy var  statusesArray : [StatusViewModel] = [StatusViewModel]()
    
    fileprivate lazy var  tipLabel : UILabel = UILabel()
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        visitorView.addRotationAnim()
        
        // 1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        
        // 2.设置导航栏的内容
        setupNavigationBar()
        
        
        
        //3、 请求数据
//        loadStatues()
        
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        
        
//        refreshControl = UIRefreshControl()
//        
//        let demoView = UIView(frame: CGRect(x: 100, y: 0, width: 175, height: 60))
//        demoView.backgroundColor = UIColor.red
//        
//        refreshControl?.addSubview(demoView)
        
        
        //布局header
        
        setupHeaderView()
        setupFooterView()
        
        
        
        setupTipLabel()
        setupNotifications()
    }
}


// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        
        //1、设置左侧的Item
        
        
        //        let leftBtn = UIButton();
        //        leftBtn.setImage(UIImage(named:"navigationbar_friendattention"), for: .normal)
        //        leftBtn.setImage(UIImage(named:"navigationbar_friendattention_highlighted"), for: .highlighted)
        //        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention") //UIBarButtonItem(customView: leftBtn)
        
        
        //2、设置右侧的Item
        //        let rightBtn = UIButton();
        //        rightBtn.setImage(UIImage(named:"navigationbar_pop"), for: .normal)
        //        rightBtn.setImage(UIImage(named:"navigationbar_pop_highlighted"), for: .highlighted)
        //        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")// UIBarButtonItem(customView: rightBtn)
        
        // 3.设置titleView
        titleBtn.setTitle("智睿Maser", for: .normal)
        //        titleBtn.addTarget(self, action:#selector("titleBtnClick:"), for: .touchUpInside)
        
        
        titleBtn.addTarget(self, action:#selector(HomeViewController.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    
    fileprivate func setupHeaderView(){
    
    
    //1、创建headerView
        
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
    
        // 2.设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        // 3.设置tableView的header
        tableView.mj_header = header
        
        // 4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
     fileprivate func setupFooterView(){
          tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatuses))
        
    }
    
    fileprivate func setupTipLabel(){
    
    //1、将tipLabel添加父控件
       navigationController?.navigationBar.insertSubview(tipLabel, at: 0) //addSubview(tipLabel)
    
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        //设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        
    
    }
    
    
    //注册通知
    
    fileprivate func setupNotifications(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser), name: NSNotification.Name(rawValue: ShowPhotoBrowerNote), object: nil)
    
    
    }
    
    
    
    
    
}
// MARK:- 事件监听的函数
extension HomeViewController {
    @objc fileprivate  func titleBtnClick(titleBtn : TitleButton) {
        // 1.改变按钮的状态
        titleBtn.isSelected = !titleBtn.isSelected
        // 2.创建弹出的控制器
        let popoverVc = PopoverViewController()
        // 3.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        // 4.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: UIScreen.main.bounds.size.width / 2.0 - 90, y: 55, width: 180, height: 260)
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(note : NSNotification){
    
//    print(note.userInfo ?? "123")
        

        
        //0、取出数据
        
        let indexPath = note.userInfo?[ShowPhotoBrowserIndexKey] as! IndexPath
        
        let picURLs = note.userInfo?[ShowPhotoBrowserUrlKey] as! [URL]
        
        
        
        let object = note.object as! PicCollectionView
        
        
      
        //1、创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath : indexPath, picURLs : picURLs)
        
        
        
        //设置model样式
        photoBrowserVc.modalPresentationStyle = .custom
        
        
        
        //设置转场
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
//        // 4.设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath as NSIndexPath?
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        //2、 以modal的形式弹出控制器
        
        
        present(photoBrowserVc, animated: true, completion: nil)
        
        
        
    
    }
    
    
}

// MARK:- 请求数据
extension HomeViewController{
    
    
    /// 加载最新的数据
    @objc fileprivate func loadNewStatuses() {
        loadStatuses(isNewData: true)
    }
    
    
    /// 加载最新的数据
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(isNewData: false)
    }
    
    
    fileprivate func loadStatuses(isNewData : Bool){
        
        
        // 1.获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id =  statusesArray.first?.status?.mid ?? 0
        }else {
            max_id = statusesArray.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        
       
        CCNetworkTool.sharInStance.loadStatues(since_id: since_id,max_id : max_id) { (result, error) in
            
            
            
            if error != nil {
                
                
                
                return;
            }
            
            guard let resultArray  = result else{
                
                
                return
            }
            
            
            
            
            //遍历微博对应的字典
            
            var tempViewModel = [StatusViewModel]()
            
            for statusDict in resultArray{

                let status = Status(dict: statusDict)
                
                
                let statusViewModel = StatusViewModel(status : status)
                tempViewModel.append(statusViewModel)
//                self.tableView.reloadData()
                
                
                
                //缓存图片
                
            }
            
            
            // 将数据放入成员变量的数组中
            // 4.将数据放入到成员变量的数组中
            if isNewData {
            self.statusesArray = tempViewModel + self.statusesArray
            
            }else {
                self.statusesArray += tempViewModel
            }
            
              self.cacheImage(viewModels: tempViewModel)
            
          
        }
    }
    
    
    
    
    func cacheImage(viewModels : [StatusViewModel]){
        
        
        //创建group
        
        
        // 0.创建group
        let group = DispatchGroup()
        
        
        //缓存图片
        for viewModels  in viewModels {
            
            for picURL in viewModels.picURLs {
                  group.enter()
                SDWebImageManager.shared().downloadImage(with: picURL as URL!, options: [], progress: nil, completed: { (_, _, _, _, _) in
//                    print("下载了一张图片")
                  group.leave()
                })
                
                
                
            }
            
        }
        
        // 2.刷新表格
        
        
       group.notify(queue: DispatchQueue.main, execute: {
           self.tableView.reloadData()
        
        
        
        
        //停止刷新
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
       
        //显示提示的Label
        
        // 显示提示的Label
        self.showTipLabel(count: viewModels.count)
       
       
       
       })
        
//        dispatch_group_notify(group, DispatchQueue.main) { () -> Void in
//            print("刷新表格")
//            self.tableView.reloadData()
//        }
        
        
        
    }
    
    
    
    fileprivate func showTipLabel(count : Int) {
    
    
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有数据" : "\(count)条新微博"
        
        //执行动画
        
//        UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>)
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.tipLabel.frame.origin.y = 44
        }) { (_) -> Void in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { () -> Void in
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) -> Void in
                self.tipLabel.isHidden = true
            })
        }
    
    
    }
    
    
    
    
    
}




extension HomeViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell") as! HomeViewCell
        
        let statusViewModel = self.statusesArray[indexPath.row]
        
        cell.viewModel = statusViewModel

//        cell.textLabel?.text = statusViewModel.status?.text
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let viewModel = statusesArray[indexPath.row]
        return viewModel.cellHeight
        
        
    }



}




