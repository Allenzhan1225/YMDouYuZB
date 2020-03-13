//
//  UIBarButtonItem_Extention.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/9.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    //构造函数实现方式
    //拓展里面拓展构造函数，只能是便利构造函数
    /*
     便利构造函数特点
     1.必须以 convenience 开头
     2.在构造函数里面必须明确调用一个设计实现的构造函数（self 调用）
     */
    convenience init(imageName:String, hilightImageName:String = "",size : CGSize = CGSize.zero){
        let btn  = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if hilightImageName != ""{
            btn.setImage(UIImage(named: hilightImageName), for: .highlighted)
        }
        
        if size != CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        self.init(customView:btn) 
    }
    
    //类方法扩充
    class func createItem(imageName:String, hilightImageName:String ,size : CGSize) -> UIBarButtonItem {
        let btn  = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: hilightImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return UIBarButtonItem(customView: btn)
    }
}
