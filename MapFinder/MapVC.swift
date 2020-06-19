//
//  ViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    var venueSearchLoc = CLLocationCoordinate2D()
    var foodChoise = (String(),String())
    
    @IBAction func locationButton(_ sender: Any) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else { return }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            let location:CLLocationCoordinate2D = currentLocation.coordinate
            venueSearchLoc = location
            self.dispMap.region = MKCoordinateRegion(center: location, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let allAnnotations = self.dispMap.annotations
        self.dispMap.removeAnnotations(allAnnotations)
        
        let handler = NetworkGurunaviService()
        handler.searchAroundVenue(loc: self.venueSearchLoc, category: self.foodChoise, completion: {(restList) in
            
            for i in restList{
                print(i.name,i.budget,i.latitude)
                
                if let lat = Double(i.latitude){
                    if let long = Double(i.longitude) {
                        let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        self.setPin(loc: loc, title: i.name)
                    }
                }
            }
        })
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputText.delegate = self
        let testLoc = CLLocationCoordinate2D(latitude: 35.6776117, longitude: 139.7651235)
        self.venueSearchLoc = testLoc
        self.dispMap.region = MKCoordinateRegion(center: testLoc, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        setPin(loc: testLoc, title: "東京駅")
     }
    
    override func viewDidAppear(_ animated: Bool) {
        print(foodChoise)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchKey = textField.text else { return false }
            
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
        
            guard let unwrapPlacemarks = placemarks else { return }
            guard let firstPlacemark = unwrapPlacemarks.first else { return }
            guard let location = firstPlacemark.location else { return }

            let coordinate = location.coordinate
            self.venueSearchLoc = coordinate
            self.setPin(loc: coordinate, title: searchKey)
            self.dispMap.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                    
        })
        
        return true
    }
    
    func setPin(loc:CLLocationCoordinate2D,title:String){
        
        let pin = MKPointAnnotation()
        pin.coordinate = loc
       
        if title != ""{
           pin.title = title
        }

        self.dispMap.addAnnotation(pin)
    }
            
}
