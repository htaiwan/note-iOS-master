//
//  HTReusePool.swift
//  HTDemo
//
//  Created by Alex Cheng on 2019/3/11.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class HTReusePool: NSObject {
    // 等待使用的隊列
    var waitUsedQueue: NSMutableSet?
    // 正在使用的隊列
    var usingQueue: NSMutableSet?
    
    override init() {
        super.init()
        
        waitUsedQueue = NSMutableSet()
        usingQueue = NSMutableSet()
    }
    
    // 從pool取得可複用的view
    func dequeueReusableView() -> UIView? {
        let view = waitUsedQueue?.anyObject()
        if view == nil {
            return nil
        } else {
            // 將view從waitUsedQueue放到usingQueue
            waitUsedQueue?.remove(view!)
            usingQueue?.add(view!)
            return view as? UIView
        }
    }
    
    // 加入一個view到pool中
    func addUsingView(_ view: UIView?) {
        if view == nil {
            return
        }
        
        usingQueue?.add(view!)
    }
    
    // 清空pool中所有的view
    func reset() {
        while usingQueue?.anyObject() != nil {
            let view = usingQueue?.anyObject()
            // 將usingQueue中的view全部移到waitUsedQueue中
            usingQueue?.remove(view!)
            waitUsedQueue?.add(view!)
        }
    }

}
