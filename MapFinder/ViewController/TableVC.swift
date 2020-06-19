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

        let shop = restList[indexPath.row]
        cell.shopname.text = shop.name
        cell.price.text = "予算:" + String(shop.budget) + "円"
        cell.opentime.text = "営業時間:" + shop.opentime
        cell.nearStation.text = "最寄駅:" + shop.access.station
        
        let image = shop.image_url.shop_image1
        
        if image.isEmpty {
            cell.imageview.image = UIImage(named: "noimage")
        }else{
            cell.imageview.image = UIImage(url: image)
        }
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
