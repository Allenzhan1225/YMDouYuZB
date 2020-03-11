//
//  HomeViewController.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/9.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK:- 懒加载属性
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFream = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFream, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = { [weak self] in
        let originY = kStatusBarH + kNavigationBarH + kTitleViewH
        let contentViewH = kScreenH - originY - kTabBarH
        let contentFrame = CGRect(x: 0, y: originY, width: kScreenW, height: contentViewH)
        
        var childVcs = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    // MARK:-系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
    }

}

// MARK:- 设置UI
extension HomeViewController {
    
    private func setupUI(){
        //设置导航栏
        setupNavigationBar()
        //添加titleView
        view.addSubview(pageTitleView)
        //添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = .yellow
    }
    
    
    
    //设置导航栏
    private func setupNavigationBar(){
        
        //左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //右边按钮  
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName:"image_my_history" , hilightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", hilightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", hilightImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
        
    }
}


// MARK:-PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, seletedIndex index: Int) {
       self.pageContentView.setCurrentIndex(currentIndex: index)
    }
}


// MARK:- PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progrerss: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
}
