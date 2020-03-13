//
//  NetworkTools.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools{
   public class func requestData(type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping (_ result : Any) -> ()){
        //1. 获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (responseObj) in

            guard let data = responseObj.result.value else{
                print(responseObj.result.error ?? "")
                return
            }
//            print(data)
            finishedCallback(data)
        }
    }
    
}
