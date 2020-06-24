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

protocol RestMapDelegate {
    func selectAnnotation(index:Int)
}

class MapVC: UIViewController, MKMapViewDelegate, FloatingPanelControllerDelegate,RestMapDelegate{
    
    @IBOutlet weak var dispMap: MKMapView!

    var fpc:FloatingPanelController!
    var currentLocation = CLLocation()
    var foodChoise = (String(),String())
    var restList = [Restaurant]()
    var annotations = [RestAnnotation]()
    
    func selectAnnotation(index: Int) {
        dispMap.selectAnnotation(annotations[index], animated: true)
    }
    
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
                let lat = Double(rest.latitude)
                let long = Double(rest.longitude)
                let location = CLLocation(latitude: lat!, longitude: long!)
                self.setRestPin(loc: location.coordinate, title: rest.name, rest: rest)
            }
            self.restList = self.calcDistance(restList: restList)
            self.showSemiModal(restList: self.restList,storyBoardID: "all")
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
        dispMap.delegate = self
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        fpc.removePanelFromParent(animated: false)
        annotations.removeAll()
    }
    
    func setRestPin(loc:CLLocationCoordinate2D,title:String,rest:Restaurant){
        let pin = RestAnnotation()
        pin.coordinate = loc
        pin.title = title
        pin.rest = rest
        annotations.append(pin)
        self.dispMap.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        removeSemiModal()
        if let annotation = view.annotation as? RestAnnotation {
            self.showSemiModal(restList: [annotation.rest],storyBoardID: "selected")
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeSemiModal()
        showSemiModal(restList: restList,storyBoardID: "all")
    }
    
    func showSemiModal(restList:[Restaurant],storyBoardID:String){
                           
        fpc = FloatingPanelController()
        
        fpc.delegate = self
           
        fpc.surfaceView.cornerRadius = 24.0
    
        if storyBoardID == "all"{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID) as? SemiModalVC else {
                return
            }
            vc.restList = restList
            vc.delegate = self
            fpc.set(contentViewController: vc)
        } else if storyBoardID == "selected"{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyBoardID) as? SelectedVC else {
                return
            }
            vc.shop = restList[0]
            fpc.set(contentViewController: vc)
        }
                           
        fpc.addPanel(toParent: self)
    }
    
    func removeSemiModal(){
        fpc.removePanelFromParent(animated: false)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
           return MyFloatingPanelLayout()
       }
}

