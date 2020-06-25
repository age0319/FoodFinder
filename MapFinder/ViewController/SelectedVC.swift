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
    
    @IBAction func onRoute(_ sender: Any) {
        delegate?.showRoute(dest: shop.location)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeButton.layer.cornerRadius = 10
        routeButton.layer.borderWidth = 1
        routeButton.layer.borderColor = UIColor.link.cgColor
        
        webButton.layer.cornerRadius = 10
        webButton.layer.borderWidth = 1
        webButton.layer.borderColor = UIColor.link.cgColor
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

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! WebVC
        controller.title = shop.name
        controller.link = shop.url
    }
}
