//
//  HomeViewController.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/9.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
    }

}

// MARK:- 设置UI
extension HomeViewController {
    
    private func setupUI(){
       setupNavigationBar()
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
