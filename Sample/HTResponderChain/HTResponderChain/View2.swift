//
//  View2.swift
//  HTResponderChain
//
//  Created by Alex Cheng on 2019/3/22.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class View2: UIView {
    
    // 如何強制讓View2-1進行處理
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 因為View2-1有一部分在View2的範圍外，
        // 所以在View2中這if判斷式，就有可能不會進入，
        // 也導致系統的預設行為模式，在這樣的情況下就會找不到responder view，無法產生回應
        if self.point(inside: point, with: event) {
            // 是在當前View中
            let subviews = self.subviews
            // 倒序,從最後一個view開始找起
            for i in  stride(from: subviews.count, to: 0, by: -1) {
                let subview = subviews[i-1]
                // 座標轉換到子視圖
                let newPoint = self.convert(point, to: subview)
                // 得到子視圖hitTest方法的返回值
                let view = subview.hitTest(newPoint, with: event)
                // 如果子視圖有返回View, 就中斷迴圈
                if view != nil {
                    return view!
                }
            }
            
            // 所有子視圖都沒返回，就回本身
            return self
        } else {
            // 點到的地方View2外
            // 卻在View2-1內
            let subviews = self.subviews
            // 倒序,從最後一個view開始找起
            for i in  stride(from: subviews.count, to: 0, by: -1) {
                let subview = subviews[i-1]
                // 座標轉換到子視圖
                let newPoint = self.convert(point, to: subview)
                // 檢查點是否在View2-1內
                if subview is View2_1 && subview.point(inside: newPoint, with: event) {
                    // 將事件強制傳給View2-1
                    let _ = subview.hitTest(newPoint, with: event)
                    return subview
                }
            }
            // 不在當前View中
            return nil
        }
    }

//    // 正常版本
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let resonderView = getResonderView(point, with: event)
//        if resonderView != nil {
//            if resonderView == self {
//                print("View2進行處理");
//            }
//        }
//
//        return resonderView
//    }

}
