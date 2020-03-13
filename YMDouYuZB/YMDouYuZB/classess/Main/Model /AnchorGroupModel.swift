//
//  AnchorGroupModel.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

class AnchorGroupModel: NSObject {
    //改组中对应的房间信息
    @objc var room_list : [[String : NSObject]]?{
        didSet{
            guard let room_list = room_list else { return }
            for dict in room_list{
                anchors.append(AnchorModel(dict:dict))
            }
        }
    }
    //显示标题
    @objc var tag_name : String = ""
    //组显示的图标
    @objc var icon_name : String = "home_header_normal"
    //定义主播模型对象数组
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    //构造函数
    override init() {
        
    }
    
    init(dict : [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
