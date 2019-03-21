//
//  HTReuseViewController.swift
//  HTDemo
//
//  Created by Alex Cheng on 2019/3/11.
//  Copyright © 2019 Alex Cheng. All rights reserved.
//

import UIKit

class HTReuseViewController: UIViewController {

    var dataSource: [String]?

    @IBOutlet weak var tableView: HTReuseTableView!
    @IBAction func reloadTable(_ sender: UIButton) {
        print("reload Data")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.indexDataSource = self
        
        dataSource = [String]()
        for i in 0..<100 {
            dataSource?.append("\(i+1)")
        }
    }
    
}

extension HTReuseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseId")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseId")
        }
        
        cell?.textLabel?.text = dataSource?[indexPath.row]
        
        return cell!
    }

}

extension HTReuseViewController: HTReuseTableViewDataSource {
    
    static var change = false
    
    func indexTitlesForIndexTableView(_ tableView: UITableView) -> [String] {
        
        if HTReuseViewController.change {
            HTReuseViewController.change = false
            return ["A","B","C","D","E","F","G","H","I","J","K"]
        } else {
            HTReuseViewController.change = true
             return ["A","B","C","D","E","F"]
        }
    }
    
}
