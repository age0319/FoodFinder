//
//  SelectedVC.swift
//  MapFinder
//
//  Created by haru on 2020/06/24.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class SelectedVC:UIViewController{
    
    @IBOutlet weak var shopname: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    var shop:Restaurant!
    var delegate:RestMapDelegate?
    @IBOutlet weak var routeButton: RoundButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var opentime: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var holiday: UILabel!
    @IBOutlet weak var pr: UILabel!
    
    @IBAction func onRoute(_ sender: Any) {
        delegate?.showMe(shop:shop)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shopname.text = shop.name
        
        var image = shop.image_url.shop_image1
               
        if image.isEmpty {
           image1.image = UIImage(named: "noimage")
        }else{
           image1.image = UIImage(url: image)
        }
        
        image = shop.image_url.shop_image2
               
        if image.isEmpty {
           image2.image = UIImage(named: "noimage")
        }else{
           image2.image = UIImage(url: image)
        }
        
        station.text = "最寄駅:" + shop.access.station
        line.text = "路線:" + shop.access.line
        distance.text = "現在地からの距離:" + String(shop.distance) + "m"
        budget.text = "平均予算:" + String(shop.budget) + "円"
        opentime.text = "営業時間:" + shop.opentime
        category.text = "カテゴリー:" + shop.category
        tel.text = "TEL:" + shop.tel
        address.text = "住所:" + shop.address
        holiday.text = "休業日:" + shop.holiday
        pr.text = "PR:" + shop.pr.pr_short

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! WebVC
        controller.title = shop.name
        controller.link = shop.url
    }
}
