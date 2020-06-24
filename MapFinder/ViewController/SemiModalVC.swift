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
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var restnameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var budget: UILabel!
    
}

class SemiModalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var restList = [Restaurant]()
    var backup = [Restaurant]()
    var delegate:RestMapDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fpccell", for: indexPath) as! FPCCell
        
        let rest = restList[indexPath.row]
        cell.restnameLabel.text = rest.name
        cell.distanceLabel.text = String(rest.distance) + "m"
        cell.station.text = String(rest.access.station)
        cell.budget.text = "平均予算:" + String(rest.budget) + "円"
        
        let image = rest.image_url.shop_image1
        
        if image.isEmpty {
            cell.imageview.image = UIImage(named: "noimage")
        }else{
            cell.imageview.image = UIImage(url: image)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectAnnotation(index: indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexpath = self.myTableView.indexPathForSelectedRow{
            let rest = restList[indexpath.row]
            let controller = segue.destination as! DetailVC
            controller.title = rest.name
            controller.link = rest.url
        }
    }
    
}
