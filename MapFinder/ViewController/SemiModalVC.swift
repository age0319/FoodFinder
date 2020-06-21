//
//  SemiModalVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/20.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class FPCCell:UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
}

class SemiModalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let data = ["hoge","fuga","koje","1","2","3","4","4","4","4","4","1","2","3","4","4","4","4","4"]
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "fpccell", for: indexPath) as! FPCCell
//        cell.label.text = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fpccell", for: indexPath) as! FPCCell
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
}
