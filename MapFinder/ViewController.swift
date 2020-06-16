//
//  ViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import MapKit
import FoursquareAPIClient

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    @IBAction func locationButton(_ sender: Any) {
    }
    
    @IBAction func searchButton(_ sender: Any) {
         searchAroundVenue(loc: currentlocation)
    }
    
    var currentlocation = CLLocationCoordinate2D()
    
    var venueList:[(name:String, lat:Double, lng:Double, category:String?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
     }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if var searchKey = textField.text{
//            print(searchKey)
            
            let geocoder = CLGeocoder()
            
            searchKey = "東京駅"
        
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
            
                if let unwrapPlacemarks = placemarks{
                    if let firstPlacemark = unwrapPlacemarks.first{
                        if let location = firstPlacemark.location{
                            let coordinate = location.coordinate
                            print(coordinate)
                            
                            self.currentlocation = coordinate
                            
                            let pin = MKPointAnnotation()
                            
                            pin.coordinate = coordinate
                            pin.title = searchKey
                            
                            self.dispMap.addAnnotation(pin)
                            self.dispMap.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
        }
        
        return true
    }
    
    func coordinateToString(loc:CLLocationCoordinate2D) -> String{
        return String(loc.latitude)+","+String(loc.longitude)
    }
    
    func doubleToCoordinate(lat:Double,lng:Double) -> CLLocationCoordinate2D{
        var loc = CLLocationCoordinate2D()
        loc.latitude = lat
        loc.longitude = lng
        return loc
    }
    
    func searchAroundVenue(loc:CLLocationCoordinate2D){
        
        let clientId = "JN0UJMZ0JDVEPJ3B1N2BTHYDUBZ1LLOXC0ZVEEWZZL5UXLPD"
        let clientSecret = "5MXF4GNXS3QZTNW0YSLQRHG5LWY2RWKA1SKHAAJDBS2OSJ3F"
        let loc = coordinateToString(loc: loc)
        let radius = 500
        let version = "20200601"
        let query = "sushi"
        
        var url = "https://api.foursquare.com/v2/venues/explore?&client_id=" + clientId
        url += "&client_secret=" + clientSecret
        url += "&v=" + version
        url += "&ll=" + loc
        url += "&query=" + query
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

            for venue in self.venueList{
                print(venue.name)
                print(venue.lat,venue.lng)

                let pin = MKPointAnnotation()

                pin.coordinate = self.doubleToCoordinate(lat: venue.lat, lng: venue.lng)
                pin.title = venue.name

                self.dispMap.addAnnotation(pin)
            }
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

