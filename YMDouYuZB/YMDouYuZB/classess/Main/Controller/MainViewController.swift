//
//  MainViewController.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/9.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChileVC(stroyName:"Home")
        addChileVC(stroyName:"Live")
        addChileVC(stroyName:"Follow")
        addChileVC(stroyName:"Profile")
    }
    
    private func addChileVC(stroyName :String){
        let childVc = UIStoryboard(name: stroyName, bundle: nil).instantiateInitialViewController()!
        addChild(childVc)
    }
}
