//
//  HTReuseTableView.swift
//  HTDemo
//
//  Created by Alex Cheng on 2019/3/11.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

protocol HTReuseTableViewDataSource: class {
    func indexTitlesForIndexTableView(_ tableView: UITableView) -> [String]
}

class HTReuseTableView: UITableView {
    private var containerView: UIView?
    private var reusePool: HTReusePool?
    weak var indexDataSource: HTReuseTableViewDataSource?
    
    override func reloadData() {
        super.reloadData()
        
        if containerView == nil {
            containerView = UIView(frame: CGRect.zero)
            containerView?.backgroundColor = UIColor.blue
            
            superview?.insertSubview(containerView!, aboveSubview: self)
        }
        
        if reusePool == nil {
            reusePool = HTReusePool.init()
        }
        
        reusePool?.reset()
        reloadIndexedBar()
    }
    
    func reloadIndexedBar() {
  
        guard let titles = indexDataSource?.indexTitlesForIndexTableView(self)  else {
            containerView?.isHidden = true
            return
        }
        
        let count = titles.count
        let width = 60
        let height = frame.size.height / CGFloat(count)
        
        for i in 0..<count {
            let title = titles[i]
            
            var button = reusePool?.dequeueReusableView() as? UIButton
            if button == nil {
                button = UIButton.init(frame: CGRect.zero)
                button!.backgroundColor = UIColor.green
                reusePool?.addUsingView(button)
                print("創建新button")
            } else {
                print("重用button")
            }
            
            containerView?.addSubview(button!)
            button!.setTitle(title, for: UIControl.State.normal)
            button!.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button!.frame  = CGRect(x: 0.0, y: height * CGFloat(i), width: CGFloat(width), height: height)
            
        }
        
        containerView?.isHidden = false
        containerView?.frame = CGRect(x: frame.origin.x + frame.size.width - CGFloat(width), y: frame.origin.y, width: CGFloat(width), height: frame.size.height)
    }
    
}
