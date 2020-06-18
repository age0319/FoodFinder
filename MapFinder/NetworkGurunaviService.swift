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
        url += "&hit_per_page=" + String(20)
        
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
            completion(self.restList)
        }
    }

    func ParseJSON(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode(RestaurantJSON.self, from: data)
            print("pass")
            
            for i in json.rest{
                let rest = Restaurant(name: i.name, latitude: i.latitude, longitude: i.longitude, url: i.url, image_url: i.image_url, opentime: i.opentime, access: i.access, budget: i.budget)
                restList.append(rest)
            }
        } catch  {
            print("エラー")
        }
            
    }
}
