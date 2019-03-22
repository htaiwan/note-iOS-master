//
//  View1-2.swift
//  HTResponderChain
//
//  Created by Alex Cheng on 2019/3/22.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class View1_2: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let resonderView = getResonderView(point, with: event)
        if resonderView != nil {
            if resonderView == self {
                print("View1_2進行處理");
            }
        }
        
        return resonderView
    }

}
