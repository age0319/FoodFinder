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



class MapVC: UIViewController, MKMapViewDelegate, FloatingPanelControllerDelegate{
    
    @IBOutlet weak var dispMap: MKMapView!
    
    var currentLocation = CLLocation()
    var foodChoise = (String(),String())
    
    var navController = UINavigationController()
    var tablevc = TableVC()
    var modalvc = SemiModalVC()
    var annotationList = [RestAnnotation]()
    
    @IBAction func locationButton(_ sender: Any) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else { return }

            self.currentLocation = currentLocation
            dispMap.region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let allAnnotations = self.dispMap.annotations
        self.dispMap.removeAnnotations(allAnnotations)
        
        let handler = NetworkGurunaviService()
        handler.searchAroundVenue(loc: self.currentLocation.coordinate, category: self.foodChoise, completion: {(restList) in
            
            for rest in restList{
                print(rest.name,rest.budget,rest.latitude)
                
                //緯度経度情報がないお店はピンがセットされない。
                if let lat = Double(rest.latitude){
                    if let long = Double(rest.longitude) {
                        let location = CLLocation(latitude: lat, longitude: long)
                            self.setRestPin(loc: location.coordinate, title: rest.name, rest: rest)
                    }
                }
            }

            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "fpc") as? SemiModalVC else {
                return
            }
            
            vc.restList = self.calcDistance(restList: restList)
            self.showSemiModal(vc: vc)
        })
    }
    
    func calcDistance(restList:[Restaurant]) -> [Restaurant]{
        for rest in restList{
            rest.setDistance(loc: currentLocation)
        }
        return restList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dispMap.delegate = self
     }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchKey = textField.text else { return false }
        
        let geocoder = CLGeocoder()
    
        geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
        
            guard let unwrapPlacemarks = placemarks else { return }
            guard let firstPlacemark = unwrapPlacemarks.first else { return }
            guard let location = firstPlacemark.location else { return }
            
            self.currentLocation = location
            self.setPin(loc: location.coordinate, title: searchKey)
            self.dispMap.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? RestAnnotation {
            print(annotation.title!)
            print(annotation.rest.access)
        }
    }
    
    func showSemiModal(vc:SemiModalVC){
        
        let fpc = FloatingPanelController()
                   
        fpc.delegate = self
           
        fpc.surfaceView.cornerRadius = 24.0
                
        fpc.set(contentViewController: vc)
                   
        // セミモーダルビューを表示する
        fpc.addPanel(toParent: self)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
           return MyFloatingPanelLayout()
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

class MyFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 16.0 // A top inset from safe area
            case .half: return 216.0 // A bottom inset from the safe area
            case .tip: return 44.0 // A bottom inset from the safe area
            default: return nil // Or `case .hidden: return nil`
        }
    }
}
