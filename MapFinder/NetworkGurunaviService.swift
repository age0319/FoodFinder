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
    
    func searchAroundVenue(loc:CLLocationCoordinate2D,completion: @escaping (String?) -> ()){
               
        var url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=" + keyId
        url += "&latitude=" + String(loc.latitude)
        url += "&longitude=" + String(loc.longitude)
        url += "&category_l=" + "RSFST08000" //ラーメン
        
        
        let req_url = URL(string: url)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
            print(String(data:data!, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
            dispatchGroup.leave()
            })
        
        task.resume()

        dispatchGroup.notify(queue: .main){
            print("hoge")
            completion("hoge")
        }
    }

    func ParseJSON(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode(CategoryJSON.self, from: data)
            
            let items = json.category_l
            
            for item in items{
                let code = item.category_l_code
                let name = item.category_l_name
                categoryList.append((code,name))
            }
            
        } catch  {
            print("エラー")
        }
            
    }
}
