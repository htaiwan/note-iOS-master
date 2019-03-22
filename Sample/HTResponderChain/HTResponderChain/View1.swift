//
//  View1.swift
//  HTResponderChain
//
//  Created by Alex Cheng on 2019/3/22.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class View1: UIView {
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let resonderView = getResonderView(point, with: event)
//        if resonderView != nil {
//            if resonderView == self {
//                print("View1進行處理");
//            }
//        }
//        
//        return resonderView
//    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 觸碰點是否在當前View中
        if self.point(inside: point, with: event) {
            // 是在當前View中
            let subviews = self.subviews
            // 倒序,從最後一個view開始找起
            for i in  stride(from: subviews.count, to: 0, by: -1) {
                let subview = subviews[i-1]
                // 座標轉換到子視圖
                let newPoint = self.convert(point, to: subview)
                // 得到子視圖hitTest方法的返回值
                let _ = subview.hitTest(newPoint, with: event)
                // 強制改寫, 因為要強制View1_1，所以也不用管hitTest方法的返回值
                if subview is View1_1 {
                    return subview
                }
            }
            
            // 所有子視圖都沒返回，就回本身
            return self
        }
        
        // 不在當前View中
        return nil
    }

}
