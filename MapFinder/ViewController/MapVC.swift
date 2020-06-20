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

class MapVC: UIViewController, UITextFieldDelegate, MKMapViewDelegate{

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    var fpc: FloatingPanelController!
    
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
            
            for i in restList{
                print(i.name,i.budget,i.latitude)
                
                if let lat = Double(i.latitude){
                    if let long = Double(i.longitude) {
                        let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        self.setPin(loc: loc, title: i.name)
                    }
                }
            }
            
            self.dispMap.region = MKCoordinateRegion(center: self.venueSearchLoc, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
            self.navController = self.tabBarController?.viewControllers![2] as! UINavigationController
            self.tablevc = self.navController.topViewController as! TableVC
            self.tablevc.restList = restList
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セミモーダルビューを非表示にする
        fpc.removePanelFromParent(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            print(annotation.title!!)
            showSemiModal()
        }
    }
    
    func showSemiModal(){
        fpc = FloatingPanelController()
                   
        fpc.delegate = self
           
        fpc.surfaceView.cornerRadius = 24.0
        
        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
        let semiModalViewController = SemiModalVC()
        fpc.set(contentViewController: semiModalViewController)
                   
        // セミモーダルビューを表示する
        fpc.addPanel(toParent: self)
    }
}

// MARK: - FloatingPanel Delegate
extension MapVC: FloatingPanelControllerDelegate {
   
   // カスタマイズしたレイアウトに変更
   func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
       return CustomFloatingPanelLayout()
   }
}

// MARK: - FloatingPanel Layout
class CustomFloatingPanelLayout: FloatingPanelLayout {
   
   // 初期位置
   var initialPosition: FloatingPanelPosition {
        return .tip
   }
   
   // カスタマイズした高さ
   func insetFor(position: FloatingPanelPosition) -> CGFloat? {
       switch position {
       case .full: return 16.0
       case .half: return 216.0
       case .tip: return 44.0
       default: return nil
       }
   }
   
   // サポートする位置
   var supportedPositions: Set<FloatingPanelPosition> {
    return [.tip,.half]
   }
}
