//
//  NSDate-Extension.swift
//  YMDouYuZB
//
//  Created by 占益民 on 2020/3/12.
//  Copyright © 2020 占益民. All rights reserved.
//

import UIKit

extension NSDate {
    class func getCurrentTime() -> String {
        let nowDate = Date()
        let interval = nowDate.timeIntervalSince1970
        return "\(interval)"
    }
}
