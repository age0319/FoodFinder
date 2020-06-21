//
//  ViewController.swift
//  MapFinder
//
//  Created by haru on 2020/06/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

class MapVC: UIViewController, UITextFieldDelegate, MKMapViewDelegate, FloatingPanelControllerDelegate{

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    var venueSearchLoc = CLLocationCoordinate2D()
    var foodChoise = (String(),String())
    
    var navController = UINavigationController()
    var tablevc = TableVC()
    
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
            dispMap.region = MKCoordinateRegion(center: location, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let allAnnotations = self.dispMap.annotations
        self.dispMap.removeAnnotations(allAnnotations)
        
        let handler = NetworkGurunaviService()
        handler.searchAroundVenue(loc: self.venueSearchLoc, category: self.foodChoise, completion: {(restList) in
            
            for rest in restList{
                print(rest.name,rest.budget,rest.latitude)
                
                if let lat = Double(rest.latitude){
                    if let long = Double(rest.longitude) {
                        let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                        self.setPin(loc: loc, title: rest.name)
                        self.setRestPin(loc: loc, title: rest.name, rest: rest)
                    }
                }
            }
            
            self.dispMap.region = MKCoordinateRegion(center: self.venueSearchLoc, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
            self.navController = self.tabBarController?.viewControllers![2] as! UINavigationController
            self.tablevc = self.navController.topViewController as! TableVC
            self.tablevc.restList = restList
            self.showSemiModal()
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
        
        dispMap.delegate = self

     }
    
    override func viewDidAppear(_ animated: Bool) {
        print(foodChoise)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard var searchKey = textField.text else { return false }
        
        searchKey = "東京駅"
        
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
        pin.title = title
        self.dispMap.addAnnotation(pin)
    }
    
    func setRestPin(loc:CLLocationCoordinate2D,title:String,rest:Restaurant){
        let pin = RestAnnotation()
        pin.coordinate = loc
        pin.title = title
        pin.rest = rest
        
        self.dispMap.addAnnotation(pin)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // セミモーダルビューを非表示にする
//        fpc.removePanelFromParent(animated: true)
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? RestAnnotation {
            print(annotation.title!)
            print(annotation.rest.access)
            self.dispMap.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        }
        
    }
    
    func showSemiModal(){
        
        let fpc = FloatingPanelController()
                   
        fpc.delegate = self
           
        fpc.surfaceView.cornerRadius = 24.0
        
        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
//        let vc = SemiModalVC()
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "fpc") as? SemiModalVC else {
            return
        }
                
        fpc.set(contentViewController: vc)
                   
        // セミモーダルビューを表示する
        fpc.addPanel(toParent: self)
    }
}


class RestAnnotation: NSObject,MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var rest:Restaurant
    
    override init(){
        self.title = String()
        self.coordinate = CLLocationCoordinate2D()
        self.rest = Restaurant()
    }
}
