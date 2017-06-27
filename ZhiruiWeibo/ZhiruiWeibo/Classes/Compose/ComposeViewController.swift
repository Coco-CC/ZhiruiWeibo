//
//  ComposeViewController.swift
//  ZhiruiWeibo
//
//  Created by DIT on 2016/11/28.
//  Copyright © 2016年 Coco. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {
    
    @IBOutlet weak var picPickerBtn: UIButton!
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHCons: NSLayoutConstraint!
    @IBOutlet weak var emojBtn: UIButton!
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images : [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc : EmotionController = EmotionController{[weak self] (emoticon) -> () in
        
        self!.textView.insertEmoticon(emoticon: emoticon)
          self?.textViewDidChange((self?.textView)!)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        setupNavigationBar()
        setupNotifications()
        
        textView.delegate = self
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
        
    }
    
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
extension ComposeViewController{
    
    
    fileprivate func setupNavigationBar(){
        
        //1、设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //2、设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
        
        
        
        
        
    }
    
    //注册通知
    fileprivate func setupNotifications(){
        
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //监听添加照片按钮
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPhotoClickAction), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        //删除照片按钮  PicPickerRemovePhotoNote
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.removePhotoClickAction), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
    
    
    
    
    
}

// MARK:- 事件监听函数
extension ComposeViewController{
    
    
    @objc fileprivate func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClick(){
//        print("SendItemClick\(self.textView.getEmoticonString())")
        
        
        
        textView.resignFirstResponder()
        
        // 1、获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
        
        
        //定义回调函数
        
        let finishedCallback = {(isSuccess : Bool) -> ()
            in
            
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            
            self.dismiss(animated: true, completion: nil)
        
        
        
        }
        
        
        
        
        //2、调用接口发送微博
        
        
        if let image = images.first {
        
            CCNetworkTool.sharInStance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallback)

        }else {
        
            CCNetworkTool.sharInStance.sendStatus(statusText: statusText, isSuccess:finishedCallback)
        }
    }
    
    
    @objc fileprivate func removePhotoClickAction(note : NSNotification){
        
        
        
        //    print(note.object ?? "123")
        
      
        //获取image对象
        
        guard let image = note.object as? UIImage else {
            return
        }
        
        guard let index = images.index(of: image) else {
            return
        }
        
        
        images.remove(at: index)
        
        
        picPickerCollectionView.images = images
        
        
    }
    
    @IBAction func emojBtnClickAction(_ sender: UIButton) {
        
        
        
        //1、退出键盘
        
        textView.resignFirstResponder()
        
        
        textView.inputView =   textView.inputView != nil ? nil : emoticonVc.view
        
        
        textView.becomeFirstResponder()
        
        //        print("0------------------------")
    }
    
    
    
    @objc fileprivate func keyboardWillChangeFrame(note : NSNotification) {
        //         1.获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        // 4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick(_ sender: UIButton) {
        //        print("被点击了")
        //退出键盘
        textView.resignFirstResponder()
        //执行动画
        
        picPickerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        
        //        UIView.animate(withDuration: 0.5, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        UIView.animate(withDuration: 0.5, animations:{ () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
}


// MARK:- 添加照片和删除照片

extension ComposeViewController{
    
    @objc fileprivate func addPhotoClickAction(){
        
        
        print("addPhotoClickAction")
        
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        
        let ipc = UIImagePickerController()
        
        
        ipc.sourceType = .photoLibrary
        
        ipc.delegate = self
        
        // 弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
// MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        // 1.获取选中的照片
    //        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //
    //        // 2.将选中的图片添加到数组中
    //
    //
    //        print("image.size = \(image.size)")
    //
    //        images.append(image)
    //
    //
    //
    //        //3、赋值给collectionView，让他展示图片
    //
    ////        PicPickerCollectionView.images = images
    //        picPickerCollectionView.images = images
    //
    //
    //        //4、退出选择照片的控制器
    //
    //        picker.dismiss(animated: true, completion: nil)
    //
    //
    //    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1.获取选中的照片
        
        //        print(info)
        
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 2.将选中的图片添加到数组中
        
        
        //        print("image.size = \(image.size)")
        
        images.append(image)
        
        
        
        //3、赋值给collectionView，让他展示图片
        
        //        PicPickerCollectionView.images = images
        picPickerCollectionView.images = images
        
        
        //4、退出选择照片的控制器
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}






// MARK:- UItextView的代理方法
extension ComposeViewController : UITextViewDelegate{
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.placeHolderLabel.isHidden = textView.hasText
        
        
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        textView.resignFirstResponder()
    }
    
    
    
    
}
