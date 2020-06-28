//
//  NetworkGurunaviService.swift
//  MapFinder
//
//  Created by haru on 2020/06/17.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import MapKit

class NetworkGurunaviService {
    
    let keyId = "de12ee212e6eeb2bd9a331a797683318"
    var venueList:[(name:String, lat:Double, lng:Double, category:String?)] = []
    var categoryList:[(code:String, name:String)] = []
    var restList = [Restaurant]()

    func getCategory(completion: @escaping ([(String,String)]) -> ()){
        
        let url = "https://api.gnavi.co.jp/master/CategoryLargeSearchAPI/v3/?keyid=" + keyId
        
        let req_url = URL(string: url)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
       
        let task = session.dataTask(with: req, completionHandler: {
        (data, response, error) in
            session.finishTasksAndInvalidate()
            print(String(data:data!, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
            self.ParseJSON(data: data!)
            dispatchGroup.leave()
            })

            task.resume()

            dispatchGroup.notify(queue: .main){
                print(self.categoryList)
                completion(self.categoryList)
            }
    }
    
    func searchAroundVenue(loc:CLLocationCoordinate2D,category:(code:String,name:String),completion: @escaping ([Restaurant]) -> ()){
               
        var url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=" + keyId
        url += "&latitude=" + String(loc.latitude)
        url += "&longitude=" + String(loc.longitude)
        url += "&category_l=" + category.code
        //一度リクエストで得るレスポンスデータの最大件数（デフォルト:10、上限:100）
        url += "&hit_per_page=" + String(100)
        // 1:300m、2:500m、3:1000m、4:2000m、5:3000m
        url += "&range=" + String(5)
        
        let req_url = URL(string: url)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
//            print(String(data:data!, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
            self.ParseJSON(data: data!)
            dispatchGroup.leave()
            })
        
        task.resume()

        dispatchGroup.notify(queue: .main){
            completion(self.restList)
        }
    }

    func ParseJSON(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode(RestaurantJSON.self, from: data)
            
            var id = 0
            for shop in json.rest{
                let rest = Restaurant()
                
                let image = ImageClass()
                image.shop_image1 = shop.image_url.shop_image1
                image.shop_image2 = shop.image_url.shop_image2
                
                let access = AccessClass()
                access.line = shop.access.line
                access.station = shop.access.station
                access.station_exit = shop.access.station_exit
                access.walk = shop.access.walk
                
                let pr = PRClass()
                pr.pr_short = shop.pr.pr_short
                pr.pr_long = shop.pr.pr_long
                
                if (shop.latitude.isEmpty == false && shop.longitude.isEmpty == false){
                    rest.set(id:id,name: shop.name, latitude: shop.latitude, longitude: shop.longitude, url: shop.url, image_url: image, opentime: shop.opentime, access: access, budget: shop.budget,category: shop.category,address: shop.address,tel: shop.tel,holiday: shop.holiday,pr: pr)
                    restList.append(rest)
                    id += 1
                }
            }
        } catch  {
            print("エラー")
        }
            
    }
}
