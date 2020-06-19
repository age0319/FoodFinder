//
//  TableVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class ShopCell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var shopname: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var opentime: UILabel!
    @IBOutlet weak var nearStation: UILabel!
    
}

class TableVC: UITableViewController{
    var restList = [Restaurant]()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopCell
        return cell
    }
}
