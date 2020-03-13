//
//  RecommedViewModel.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

class RecommedViewModel {
    // MARK:-懒加载属性
    lazy var anchorGroups : [AnchorGroupModel] = [AnchorGroupModel]()
    private lazy var prettyGroup : AnchorGroupModel = AnchorGroupModel()
    private lazy var bigGroup : AnchorGroupModel = AnchorGroupModel()
    
}


// MARK:- 数据请求
extension RecommedViewModel {
    /*
     1 请求第一部分的推荐数据
     2 请求第二部分的颜值数据
     3 请求后面部分的游戏数据
     接口 热门数据(后面热门游戏)
     接口地址 http://capi.douyucdn.cn/api/v1/getHotCate
     请求参数
     参数名 参数说明
     time 获取当前时间的字符串
     limit 获取数据的个数
     offset 偏移的数据量
     接口名称 颜值数据
     接口地址 http://capi.douyucdn.cn/api/v1/getVerticalRoom
     请求参数
     参数名称
     time 获取当前时间的字符串
     limit 获取数据的个数
     offset 偏移的数据量
     接口名称 大数据数据 第一组热门数据
     接口地址
     http://capi.douyucdn.cn/api/v1/getbigDataRoom
     请求参数
     参数名称
     time 获取当前时间的字符串
     
     
     
     http:capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1562574873
     http:capi.douyucdn.cn/api/v1/getVerticalRoom?limit=4&offset=0&time=1562574873
     http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1562574873
     */
    
   
    func requestData(finishCallBack : @escaping () -> Void){
        let disGroup = DispatchGroup()
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
        disGroup.enter()
        //1.请求第一部分推荐数据
        NetworkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom",parameters: ["time":NSDate.getCurrentTime()]) { (response) in
            print(response)
            //1.将response 转成字典类型
            guard let resultDict = response as? [String : NSObject] else{return }
            //2.根据data key  获取到数组
            guard let dataArr = resultDict["data"] as? [[String : NSObject]] else {return }
            self.bigGroup.tag_name = "热门"
            //获取主播数据
            for dict in dataArr{
                let anchorModel = AnchorModel(dict: dict)
                self.bigGroup.anchors.append(anchorModel)
            }
            print("所有数据1")
            disGroup.leave()
        }
        disGroup.enter()
        //2.请求颜值数据
        NetworkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (response) in
            print(response)
            //1.将response 转成字典类型
            guard let resultDict = response as? [String : NSObject] else{return }
            //2.根据data key  获取到数组
            guard let dataArr = resultDict["data"] as? [[String : NSObject]] else {return }
            self.prettyGroup.tag_name = "颜值"
            //获取主播数据
            for dict in dataArr{
                let anchorModel = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchorModel)
            }
            print("所有数据2")
            disGroup.leave()
        }
        
        
        //3.请求游戏数据
        //http://capi.douyucdn.cn/api/v1/getHotCate?limit=10&offset=0&time=1583996958
        print(NSDate.getCurrentTime())
        disGroup.enter()
        NetworkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (response) in
            print(response)
            //1.将response 转成字典类型
            guard let resultDict = response as? [String : NSObject] else{return }
            //2.根据data key  获取到数组
            guard let dataArr = resultDict["data"] as? [[String : NSObject]] else {return }
            
            //3.遍历数组获取字典，并将字典转成模型数组
            for dict in dataArr{
                let group = AnchorGroupModel(dict: dict)
                self.anchorGroups.append(group)
            }
            for group in self.anchorGroups{
                print(group.tag_name)
                for anchor in group.anchors{
                    print(anchor.nickname)
                }
            }
            print("所有数据3")
            disGroup.leave()
        }
        
        disGroup.notify(queue: DispatchQueue.main) {
            print("所有数据都请求到了")
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigGroup, at: 0)
            finishCallBack()
        }
    }
}
