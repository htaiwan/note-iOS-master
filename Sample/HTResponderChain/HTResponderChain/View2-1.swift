//
//  View2-1.swift
//  HTResponderChain
//
//  Created by Alex Cheng on 2019/3/22.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class View2_1: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 事件轉發
        print("View2_1進行處理")
        return self
    }
    
    // 正常版本
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let resonderView = getResonderView(point, with: event)
//        if resonderView != nil {
//            if resonderView == self {
//                print("View2_1進行處理")
//            }
//        }
//
//        return resonderView
//    }

}
