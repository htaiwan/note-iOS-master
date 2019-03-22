//
//  View+HTResponder.swift
//  HTResponderChain
//
//  Created by Alex Cheng on 2019/3/22.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit


extension UIView {
    func getResonderView(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (self.alpha <= 0.01 || self.isUserInteractionEnabled == false || self.isHidden) {
            return nil;
        }
        
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
                let view = subview.hitTest(newPoint, with: event)
                // 如果子視圖有返回View, 就中斷迴圈
                if view != nil {
                    return view!
                }
            }
            
            // 所有子視圖都沒返回，就回本身
            return self
        }
        
        // 不在當前View中
        return nil
    }
}
