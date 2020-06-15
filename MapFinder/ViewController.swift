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
    
    var placeList:[(name:String, let:Float, lng:Float, category:String?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchKey = textField.text{
//            print(searchKey)
            
            let geocoder = CLGeocoder()
            
            let testKey = "東京駅"
        
            geocoder.geocodeAddressString(testKey, completionHandler: { (placemarks, error) in
            
                if let unwrapPlacemarks = placemarks{
                    if let firstPlacemark = unwrapPlacemarks.first{
                        if let location = firstPlacemark.location{
                            let coordinate = location.coordinate
                            print(coordinate)
                            
                            self.checkAround(loc: coordinate)
                            
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
    
    func checkAround(loc:CLLocationCoordinate2D){
        let client = FoursquareAPIClient(clientId: "JN0UJMZ0JDVEPJ3B1N2BTHYDUBZ1LLOXC0ZVEEWZZL5UXLPD",
        clientSecret: "5MXF4GNXS3QZTNW0YSLQRHG5LWY2RWKA1SKHAAJDBS2OSJ3F")
        
        let llString = String(loc.latitude)+","+String(loc.longitude)
        
        let parameter: [String: String] = [
            "ll": llString, // 緯度経度
            "limit": "10", // 一度に取得する件数
        ];
        
        client.request(path: "venues/search", parameter: parameter) {
            result in

            switch result {

                case .success(let data):
                    // 成功
                    print(String(data:data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                    self.ParseJSON(data: data)

                case .failure(.connectionError(let error)):
                    // 通信エラー
                    print(error)

                case .failure(.apiError(let error)):
                    // 通信はできたけどAPIエラー
                    print(error.errorType)   // e.g. endpoint_error
                    print(error.errorDetail) // e.g. The requested path does not exist.
                    
                case .failure(.responseParseError(_)): break
    
            }
        }
        
    }
    
    func ParseJSON(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode(ResultJson.self, from: data)
            
            let venues = json.response.venues
            
            for venue in venues{
                let place = (venue.name,venue.location.lat,venue.location.lng,venue.categories![0].name)
                placeList.append(place)
            }
            
            print(placeList)
            
        } catch  {
            print("エラー")
        }
        
    }
}

