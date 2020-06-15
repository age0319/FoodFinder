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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
        setup()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let searchKey = textField.text{
            print(searchKey)
        
            let geocoder = CLGeocoder()
        
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
            
                if let unwrapPlacemarks = placemarks{
                    if let firstPlacemark = unwrapPlacemarks.first{
                        if let location = firstPlacemark.location{
                            let coordinate = location.coordinate
                            print(coordinate)
                            
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
    
    func setup(){
        let client = FoursquareAPIClient(clientId: "JN0UJMZ0JDVEPJ3B1N2BTHYDUBZ1LLOXC0ZVEEWZZL5UXLPD",
        clientSecret: "5MXF4GNXS3QZTNW0YSLQRHG5LWY2RWKA1SKHAAJDBS2OSJ3F")
        
        let parameter: [String: String] = [
            "ll": "35.702069,139.7753269", // 緯度経度
            "limit": "1", // 一度に取得する件数
        ];
        
        client.request(path: "venues/search", parameter: parameter) {
            result in

            switch result {

            case .success(let data):
                // 成功
                print(NSString(data:data, encoding:String.Encoding.utf8.rawValue)!)

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
}

