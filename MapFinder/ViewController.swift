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
    
    var venueSearchLoc = CLLocationCoordinate2D()
    var foodChoise:(String,String) = ("","")
    
    @IBAction func locationButton(_ sender: Any) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            let location:CLLocationCoordinate2D = currentLocation.coordinate
            venueSearchLoc = location
            moveToCoordinate(loc: location, title: "")
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let handler = NetworkGurunaviService()
        handler.searchAroundVenue(loc: self.venueSearchLoc, completion: {(hoge) in
            print("")
        })
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
     }
    
    override func viewDidAppear(_ animated: Bool) {
        print(foodChoise)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if var searchKey = textField.text{
            
            let geocoder = CLGeocoder()
            
            searchKey = "東京駅"
        
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
            
                if let unwrapPlacemarks = placemarks{
                    if let firstPlacemark = unwrapPlacemarks.first{
                        if let location = firstPlacemark.location{
                            let coordinate = location.coordinate
                            
                            self.venueSearchLoc = coordinate
                            self.moveToCoordinate(loc: coordinate, title: searchKey)
                        }
                    }
                }
            })
        }
        
        return true
    }
    
    func moveToCoordinate(loc:CLLocationCoordinate2D,title:String){

        let pin = MKPointAnnotation()
        pin.coordinate = loc
        
        if title != ""{
            pin.title = title
        }
        
        self.dispMap.addAnnotation(pin)
        self.dispMap.region = MKCoordinateRegion(center: loc, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
    }
            
}
