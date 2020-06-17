//
//  NetworkService.swift
//  MapFinder
//
//  Created by haru on 2020/06/17.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import MapKit

class NetworkFourSquareService {
    
    var venueList:[(name:String, lat:Double, lng:Double, category:String?)] = []

    func searchAroundVenue(loc:CLLocationCoordinate2D,completion: @escaping ([(name:String, lat:Double, lng:Double, category:String?)]?) -> ()){
        
        let clientId = "JN0UJMZ0JDVEPJ3B1N2BTHYDUBZ1LLOXC0ZVEEWZZL5UXLPD"
        let clientSecret = "5MXF4GNXS3QZTNW0YSLQRHG5LWY2RWKA1SKHAAJDBS2OSJ3F"
        let loc = Utility().coordinateToString(loc: loc)
        let radius = 500
        let version = "20200601"
        let query = ["sushi","noodle","soba","udon"]
        
        var url = "https://api.foursquare.com/v2/venues/explore?&client_id=" + clientId
        url += "&client_secret=" + clientSecret
        url += "&v=" + version
        url += "&ll=" + loc
        url += "&query=" + query[3]
        url += "&radius=" + String(radius)
        
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
            completion(self.venueList)
        }
    }

    func ParseJSON(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode(ResultJson.self, from: data)
            
            let items = json.response.groups[0].items
            
            for item in items{
                let venue = item.venue
                let place = (venue.name,venue.location.lat,venue.location.lng,venue.categories[0].name)
                venueList.append(place)
            }
            
        } catch  {
            print("エラー")
        }
    }
}
