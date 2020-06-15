//
//  ViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
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
}

